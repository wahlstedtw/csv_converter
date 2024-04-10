defmodule CsvConverter.Text.ISBNConverter do
  def isbn13_to_isbn10(isbn13) when is_binary(isbn13) and byte_size(isbn13) == 13 do
    case String.starts_with?(isbn13, "978") do
      true ->
        isbn10_base = String.slice(isbn13, 3, 9)
        checksum = isbn10_checksum(isbn10_base)
        {:ok, isbn10_base <> Integer.to_string(checksum)}
      false ->
        {:error, "ISBN-13 must start with '978' to be convertible to ISBN-10"}
    end
  end

  # Return ISBN-10 strings unchanged
  def isbn13_to_isbn10(isbn10) when is_binary(isbn10) and byte_size(isbn10) == 10, do: {:ok, isbn10}

  defp isbn10_checksum(isbn10_base) do
    digits = String.to_charlist(isbn10_base) |> Enum.map(&(&1 - 48)) # Convert charlist to a list of digits

    sum = Enum.with_index(digits)
    |> Enum.reduce(0, fn {digit, index}, acc -> acc + digit * (10 - index) end)

    rem = rem(sum, 11)
    case rem do
      0 -> 0
      x -> 11 - x
    end
  end
end
