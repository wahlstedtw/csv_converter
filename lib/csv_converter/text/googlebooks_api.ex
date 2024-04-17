defmodule CsvConverter.Text.GoogleBooks do
  @max_retries 3  # Define a maximum number of retries

  def fetch_book_info_by_isbn(isbn, debug_mode) do
    do_fetch_book_info_by_isbn(isbn, debug_mode, 0)
  end

  defp do_fetch_book_info_by_isbn(isbn, debug_mode, retries) when retries <= @max_retries do
    base_url = "https://www.googleapis.com/books/v1/volumes"
    query = URI.encode_query(q: "isbn:#{isbn}")

    if debug_mode do
      fullgoogleurl = "#{base_url}?#{query}"
      IO.inspect(fullgoogleurl, label: "Google API Url")
    end

    case HTTPoison.get("#{base_url}?#{query}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_first_book_info(body) |> handle_response(retries, isbn, debug_mode)

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        retry_or_error(retries, isbn, debug_mode, "Unexpected status code: #{status_code}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        retry_or_error(retries, isbn, debug_mode, reason)
    end
  end

  defp do_fetch_book_info_by_isbn(_isbn, _debug_mode, retries) when retries > @max_retries do
    {:error, "Max retries exceeded"}
  end

  defp parse_first_book_info(body) do
    body
    |> Jason.decode!()
    |> Map.get("items")
    |> Enum.at(0)
    |> case do
        nil -> {:error, "No books found"}
        item ->
          description = get_in(item, ["volumeInfo", "description"]) || log_missing_description()
          title = get_in(item, ["volumeInfo", "title"]) || "Untitled"
          categories = get_in(item, ["volumeInfo", "categories"]) || ["Uncategorized"]

          {:ok, %{title: title, description: description, categories: categories}}
      end
  end

  defp log_missing_description do
    IO.puts("Logging missing description at #{DateTime.utc_now()}")
    "No description available"
  end

  defp handle_response({:ok, %{description: nil}} = response, _retries, _isbn, _debug_mode) do
    {:ok, response}
  end

  defp handle_response(response, _retries, _isbn, _debug_mode) do
    {:ok, response}
  end

  defp retry_or_error(retries, isbn, debug_mode, error_message) do
    if retries < @max_retries do
      :timer.sleep(1000)  # Wait for 1000ms before retrying
      do_fetch_book_info_by_isbn(isbn, debug_mode, retries + 1)
    else
      {:error, "#{error_message} after #{retries} retries"}
    end
  end
end
