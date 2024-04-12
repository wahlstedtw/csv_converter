defmodule Mix.Tasks.ScrapeAndExport do
  use Mix.Task

  @shortdoc "Scrapes text from Amazon book pages listed in a CSV file and exports each to a separate CSV file."

  def run(args) do
    {opts, args, _} = OptionParser.parse(args, switches: [debug: :boolean])

    debug_mode = opts[:debug] || false

    if debug_mode do
      IO.puts("Debug mode is ON")
      # You can set a global flag or pass this flag to your functions here
    else
      IO.puts("Debug mode is OFF")
    end
    # Ensure HTTPoison and its dependencies are started
    {:ok, _} = Application.ensure_all_started(:httpoison)

    [input_csv_path] = args

    # Assuming MyCSVReader is a module you've defined to read CSV files
    output_csv_path = generate_file_path()
    if debug_mode do
      IO.inspect(output_csv_path, label: "output_csv_path")
    end
    transformed_books = CsvConverter.Text.CsvTransformer.read_source_csv(input_csv_path, debug_mode)
    case CsvConverter.Text.CsvTransformer.write_destination_csv(output_csv_path, transformed_books) do
      :ok -> Mix.shell().info("Successfully exported to #{output_csv_path}")
      {:error, reason} -> Mix.shell().error("Failed to export: #{reason}")
    end

    if debug_mode do
      IO.inspect(transformed_books, label: "transformed_books")
    end

    # Enum.each(source_books, fn %{"EAN" => book_id} ->
    #   case CsvConverter.Text.CsvExport.process_and_export(book_id, file_path, debug_mode) do
    #     :ok -> Mix.shell().info("Successfully exported #{book_id} to #{file_path}")
    #     {:error, reason} -> Mix.shell().error("Failed to export #{book_id}: #{reason}")
    #   end
    # end)
  end

  def generate_file_path do
    # Get the current date and time
    current_datetime = DateTime.utc_now()

    # Format the date as a string in "YYYY-MM-DD" format
    date_string = DateTime.to_string(current_datetime)
    |> String.slice(0..9) # This slices the string to keep only the date part

    # Generate the file path with the date included in the filename
    file_path = "output/#{date_string}.csv"

    file_path
  end
end
