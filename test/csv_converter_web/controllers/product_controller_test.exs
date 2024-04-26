defmodule CsvConverterWeb.ProductControllerTest do
  use CsvConverterWeb.ConnCase

  import CsvConverter.CatalogFixtures

  @create_attrs %{status: "some status", title: "some title", body_html: "some body_html", cost_per_item: 120.5, discount: 120.5, option1_name: "some option1_name", option1_value: "some option1_value", option2_name: "some option2_name", option2_value: "some option2_value", option3_name: "some option3_name", option3_value: "some option3_value", product_category: "some product_category", published: true, variant_barcode: "some variant_barcode", variant_inventory_qty: 42, variant_price: 120.5, variant_weight_unit: "some variant_weight_unit", vendor: "some vendor", image_src: "some image_src"}
  @update_attrs %{status: "some updated status", title: "some updated title", body_html: "some updated body_html", cost_per_item: 456.7, discount: 456.7, option1_name: "some updated option1_name", option1_value: "some updated option1_value", option2_name: "some updated option2_name", option2_value: "some updated option2_value", option3_name: "some updated option3_name", option3_value: "some updated option3_value", product_category: "some updated product_category", published: false, variant_barcode: "some updated variant_barcode", variant_inventory_qty: 43, variant_price: 456.7, variant_weight_unit: "some updated variant_weight_unit", vendor: "some updated vendor", image_src: "some updated image_src"}
  @invalid_attrs %{status: nil, title: nil, body_html: nil, cost_per_item: nil, discount: nil, option1_name: nil, option1_value: nil, option2_name: nil, option2_value: nil, option3_name: nil, option3_value: nil, product_category: nil, published: nil, variant_barcode: nil, variant_inventory_qty: nil, variant_price: nil, variant_weight_unit: nil, vendor: nil, image_src: nil}

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, ~p"/products")
      assert html_response(conn, 200) =~ "Listing Products"
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/products/new")
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "create product" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/products", product: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/products/#{id}"

      conn = get(conn, ~p"/products/#{id}")
      assert html_response(conn, 200) =~ "Product #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/products", product: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, product: product} do
      conn = get(conn, ~p"/products/#{product}/edit")
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/products/#{product}", product: @update_attrs)
      assert redirected_to(conn) == ~p"/products/#{product}"

      conn = get(conn, ~p"/products/#{product}")
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/products/#{product}", product: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, ~p"/products/#{product}")
      assert redirected_to(conn) == ~p"/products"

      assert_error_sent 404, fn ->
        get(conn, ~p"/products/#{product}")
      end
    end
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
