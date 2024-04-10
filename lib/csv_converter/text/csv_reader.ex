defmodule CsvConverter.Text.CsvReader do
  @moduledoc """
  Utility to export book description from Amazon.
  """

  alias NimbleCSV.RFC4180, as: CSV

  def read_csv(file_path) do
    file_path
    # |> File.stream!()
    # |> RFC4180.parse_stream(headers: true)
    # |> Enum.map(fn row -> row["book_id"] end)
    # |> Enum.reject(&is_nil/1)  # Reject any nil values that might occur if "book_id" column is missing in some rows
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Stream.transform(nil, fn
      headers, nil -> {[], headers}
      row, headers -> {[Enum.zip(headers, row) |> Map.new()], headers}
    end)
    |> Enum.to_list()
  end
end
