defmodule CsvConverter.Text.GoogleBooks do
  def fetch_book_info_by_isbn(isbn, debug_mode) do
    base_url = "https://www.googleapis.com/books/v1/volumes"
    query = URI.encode_query(q: "isbn:#{isbn}")
    if debug_mode do
      fullgoogleurl = "#{base_url}?#{query}"
      IO.inspect(fullgoogleurl, label: "Google API Url")
    end
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
    |> Map.get("items")
    |> Enum.at(0)
    |> case do
        nil -> {:error, "No books found"}
        item ->
          description = get_in(item, ["volumeInfo", "description"]) || "No description available"
          title = get_in(item, ["volumeInfo", "title"]) || "Untitled"
          categories = get_in(item, ["volumeInfo", "categories"]) || ["Uncategorized"]

          {:ok, %{title: title, description: description, categories: categories}}
      end
    end
end
