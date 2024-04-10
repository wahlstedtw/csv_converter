defmodule CsvConverter.Text.CsvExport do
  @moduledoc """
  Utility to export book info to a csv.
  """
  def process_and_export(book_id, file_path, debug) do
    case CsvConverter.Text.ISBNConverter.isbn13_to_isbn10(book_id) do
      {:ok, isbn10} ->
          if debug do
            IO.inspect(isbn10, label: "ISBN-10")
          end
        case CsvConverter.Text.GoogleBooks.fetch_book_info_by_isbn(isbn10) do
          {:ok, {:ok, %{title: title, description: description}}} when description != "" ->
              if debug do
                IO.inspect(description, label: "Description")
              end
              if debug do
                IO.inspect(title, label: "Title")
              end
            image_url = CsvConverter.Text.OpenLibraryCover.get_cover_url(isbn10)
              if debug do
                IO.inspect(image_url, label: "image_url")
              end
            export_to_csv(description, title, file_path, image_url, book_id)
          {:ok, %{description: ""}} ->
            IO.puts("No content was extracted.")
          {:error, reason} ->
            IO.puts("Failed to fetch content: #{reason}")
        end
      {:error, reason} ->
        IO.puts("ISBN conversion failed: #{reason}")
    end
  end

  defp export_to_csv(description, title, file_path, image_url, book_id) do
    headers_needed = not File.exists?(file_path)
    headers = if headers_needed, do: "Title, Body (HTML),Image Src,Variant Barcode\n", else: ""
    csv_data_row = "#{title},\"#{description}\",#{image_url},#{book_id}\n"
    content_to_write = headers <> csv_data_row
    File.write(file_path, content_to_write, [:append])
  end
end
