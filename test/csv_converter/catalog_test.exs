defmodule CsvConverter.CatalogTest do
  use CsvConverter.DataCase

  alias CsvConverter.Catalog

  describe "products" do
    alias CsvConverter.Catalog.Product

    import CsvConverter.CatalogFixtures

    @invalid_attrs %{status: nil, title: nil, body_html: nil, cost_per_item: nil, discount: nil, option1_name: nil, option1_value: nil, option2_name: nil, option2_value: nil, option3_name: nil, option3_value: nil, product_category: nil, published: nil, variant_barcode: nil, variant_inventory_qty: nil, variant_price: nil, variant_weight_unit: nil, vendor: nil, image_src: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{status: "some status", title: "some title", body_html: "some body_html", cost_per_item: 120.5, discount: 120.5, option1_name: "some option1_name", option1_value: "some option1_value", option2_name: "some option2_name", option2_value: "some option2_value", option3_name: "some option3_name", option3_value: "some option3_value", product_category: "some product_category", published: true, variant_barcode: "some variant_barcode", variant_inventory_qty: 42, variant_price: 120.5, variant_weight_unit: "some variant_weight_unit", vendor: "some vendor", image_src: "some image_src"}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.status == "some status"
      assert product.title == "some title"
      assert product.body_html == "some body_html"
      assert product.cost_per_item == 120.5
      assert product.discount == 120.5
      assert product.option1_name == "some option1_name"
      assert product.option1_value == "some option1_value"
      assert product.option2_name == "some option2_name"
      assert product.option2_value == "some option2_value"
      assert product.option3_name == "some option3_name"
      assert product.option3_value == "some option3_value"
      assert product.product_category == "some product_category"
      assert product.published == true
      assert product.variant_barcode == "some variant_barcode"
      assert product.variant_inventory_qty == 42
      assert product.variant_price == 120.5
      assert product.variant_weight_unit == "some variant_weight_unit"
      assert product.vendor == "some vendor"
      assert product.image_src == "some image_src"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{status: "some updated status", title: "some updated title", body_html: "some updated body_html", cost_per_item: 456.7, discount: 456.7, option1_name: "some updated option1_name", option1_value: "some updated option1_value", option2_name: "some updated option2_name", option2_value: "some updated option2_value", option3_name: "some updated option3_name", option3_value: "some updated option3_value", product_category: "some updated product_category", published: false, variant_barcode: "some updated variant_barcode", variant_inventory_qty: 43, variant_price: 456.7, variant_weight_unit: "some updated variant_weight_unit", vendor: "some updated vendor", image_src: "some updated image_src"}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.status == "some updated status"
      assert product.title == "some updated title"
      assert product.body_html == "some updated body_html"
      assert product.cost_per_item == 456.7
      assert product.discount == 456.7
      assert product.option1_name == "some updated option1_name"
      assert product.option1_value == "some updated option1_value"
      assert product.option2_name == "some updated option2_name"
      assert product.option2_value == "some updated option2_value"
      assert product.option3_name == "some updated option3_name"
      assert product.option3_value == "some updated option3_value"
      assert product.product_category == "some updated product_category"
      assert product.published == false
      assert product.variant_barcode == "some updated variant_barcode"
      assert product.variant_inventory_qty == 43
      assert product.variant_price == 456.7
      assert product.variant_weight_unit == "some updated variant_weight_unit"
      assert product.vendor == "some updated vendor"
      assert product.image_src == "some updated image_src"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
