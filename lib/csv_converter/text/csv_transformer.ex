defmodule CsvConverter.Text.CsvTransformer do
  @moduledoc """
  Utility to export book description from Amazon.
  """
  alias NimbleCSV.RFC4180, as: CSV



  def read_source_csv(file_path, debug) do
    file_path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Stream.transform(nil, fn
      headers, nil -> {[], headers}
      row, headers -> {[Enum.zip(headers, row) |> Map.new()], headers}
    end)
    |> Enum.map(&transform_row(&1, debug))
  end

  def get_img_url(isbn10) do
    case CsvConverter.Text.OpenLibraryCover.get_cover_url(isbn10) do
      {:error, _reason} = error -> error
      url -> {:ok, url}
    end
  end


  def calculate_cost(cost, discount) do
    numeric_cost = case String.contains?(cost, ".") do
      true -> String.to_float(cost)
      false -> String.to_float(cost <> ".0")
    end
    numeric_discount = String.to_float(discount)
    final_cost = Float.round(numeric_cost * (1 - (numeric_discount / 100)),2)
    final_cost
  end

  def transform_row(row, debug_mode) do
    :timer.sleep(500)
    isbn10 = row["EAN"]

    image_url = case get_img_url(isbn10) do
      {:ok, url} -> url
      _ -> "default_image_url"
    end

    categories = case CsvConverter.Text.GoogleBooks.fetch_book_info_by_isbn(isbn10, debug_mode) do
      {:ok, {:ok, %{categories: fetched_categories}}} when fetched_categories != "" ->
        fetched_categories
      {:ok, %{categories: ""}} ->
        IO.puts("No content was extracted.")
        "default_categories"
      {:error, reason} ->
        IO.puts("Failed to fetch content: #{reason}")
        "default_categories"
    end
    description = case CsvConverter.Text.GoogleBooks.fetch_book_info_by_isbn(isbn10, debug_mode) do
      {:ok, {:ok, %{description: fetched_description}}} when fetched_description != nil  ->
        fetched_description
        # IO.puts("Description is: #{fetched_description}")
      {:ok, %{description: nil}} ->
        IO.puts("No content was extracted.")
        "default_description"
      {:error, reason} ->
        IO.puts("Failed to fetch content: #{reason}")
        "default_description"
    end
    if debug_mode do
      IO.inspect(description, label: "description")
    end

    html_output = CsvConverter.Text.DescriptionFormatter.format(description)
    IO.inspect(label: "---")
    IO.inspect(row["Title"], label: "title")
    IO.inspect(isbn10, label: "isbn10")

    if debug_mode do
      IO.inspect(html_output, label: "html_output")
      IO.inspect(row["Quantity Shipped"], label: "Quantity Shipped")
      IO.inspect(categories, label: "categories")
      IO.inspect(image_url, label: "image_url")
      IO.inspect(calculate_cost(row["Price"], row["Discount"]), label: "final_cost")
    end
  #     # "Type" => fetch_type(row["EAN"]), # Historical Fiction
  #     # "Tags" => fetch_tags(row["EAN"]),  # Stubbed function to fetch tags
  #     # "Variant Grams" => oz_to_grams(14.22),  # Example weight conversion
  #     # "Cost per item" => calculate_cost(row["Price"], 0.40),  # Stubbed function for cost calculation
        # Stubbed function for cost calculation
    %{
      "Vendor" => "INGRAM",
      "Cost per item" => calculate_cost(row["Price"], row["Discount"]),
      "Body (HTML)" => html_output,
      "Image Src" => image_url,
      "Title" => row["Title"],
      "tags" => categories,
      "Collection" => "Shop All Books",
      "Discount" => "40",
      "Product Category" => "Media > Books",
      "Published" => "TRUE",
      "Variant Inventory Qty" => row["Quantity Shipped"],
      "Variant Inventory Tracker" => "shopify",
      "Variant Price" => row["Price"],
      "Variant Barcode" => row["EAN"],
      "Variant Weight Unit" => "lb",
      "Status" => "active",
      "Option1 Name" => "Author",
      "Option1 Value" => row["Author"],
      "Option2 Name" => "Binding",
      "Option2 Value" => row["Binding"],
      "Option3 Name" => "Publisher",
      "Option3 Value" => row["Publisher"],
    }
  end

  def write_destination_csv(file_path, rows) do
    headers = Enum.map(rows, &Map.keys/1) |> List.flatten() |> Enum.uniq()
    rows_data = Enum.map(rows, fn row -> headers |> Enum.map(&Map.get(row, &1, "")) end)
    csv_data = [headers | rows_data]
    # Convert the data to a CSV format
    csv_content = CSV.dump_to_iodata(csv_data)
    # Write the CSV content to a file
    File.write(file_path, csv_content, [:append])

  end
end
