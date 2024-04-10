defmodule CsvConverter.Text.GoogleBooks do
  def fetch_book_info_by_isbn(isbn) do
    base_url = "https://www.googleapis.com/books/v1/volumes"
    query = URI.encode_query(q: "isbn:#{isbn}")
    IO.inspect(label: "#{base_url}?#{query}")
    case HTTPoison.get("#{base_url}?#{query}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_first_book_info(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        {:error, "Unexpected status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_first_book_info(body) do
    body
    |> Jason.decode!()
    |> Map.get("items")  # Get the list of items
    |> Enum.at(0)  # Safely get the first item from the list
    |> case do
      nil -> {:error, "No books found"}
      item ->
        description = get_in(item, ["volumeInfo", "description"])
        title = get_in(item, ["volumeInfo", "title"])
        categories = get_in(item, ["volumeInfo", "categories"])
        {:ok, %{title: title, description: description,categories: categories}}
    end
  end
end
