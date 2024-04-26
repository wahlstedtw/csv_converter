defmodule CsvConverter.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CsvConverter.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        body_html: "some body_html",
        cost_per_item: 120.5,
        discount: 120.5,
        image_src: "some image_src",
        option1_name: "some option1_name",
        option1_value: "some option1_value",
        option2_name: "some option2_name",
        option2_value: "some option2_value",
        option3_name: "some option3_name",
        option3_value: "some option3_value",
        product_category: "some product_category",
        published: true,
        status: "some status",
        title: "some title",
        variant_barcode: "some variant_barcode",
        variant_inventory_qty: 42,
        variant_price: 120.5,
        variant_weight_unit: "some variant_weight_unit",
        vendor: "some vendor"
      })
      |> CsvConverter.Catalog.create_product()

    product
  end
end
