defmodule CsvConverter.Text.OpenLibraryCover do
  @moduledoc """
  Fetches book cover image URLs from OpenLibrary.
  """

  # Function to construct the URL for the book cover image based on ISBN
  def get_cover_url(isbn) when is_binary(isbn) do
    "https://covers.openlibrary.org/b/isbn/#{isbn}-L.jpg"
  end
end
