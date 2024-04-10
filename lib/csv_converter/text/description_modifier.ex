defmodule CsvConverter.Text.DescriptionFormatter do
  def format(description) do
    # Split the description into paragraphs based on full stops and line breaks for simplicity
    paragraphs = String.split(description, ~r/[.]\s+|\n/, trim: true)

    # Wrap each paragraph in <p> tags and emphasize titles or key phrases
    formatted_paragraphs =
      Enum.map(paragraphs, fn paragraph ->
        # Example of emphasizing a phrase. Adapt the pattern to your needs.
        paragraph = Regex.replace(~r/#1 NEW YORK TIMES BESTSELLER/, paragraph, "<strong>\\0</strong>")

        "<p>#{paragraph}</p>"
      end)

    # Join the paragraphs back into a single HTML string
    Enum.join(formatted_paragraphs)
  end
end
