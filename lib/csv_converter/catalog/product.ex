defmodule CsvConverter.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :status, :string
    field :title, :string
    field :body_html, :string
    field :cost_per_item, :float
    field :discount, :float
    field :option1_name, :string
    field :option1_value, :string
    field :option2_name, :string
    field :option2_value, :string
    field :option3_name, :string
    field :option3_value, :string
    field :product_category, :string
    field :published, :boolean, default: false
    field :variant_barcode, :string
    field :variant_inventory_qty, :integer
    field :variant_price, :float
    field :variant_weight_unit, :string
    field :vendor, :string
    field :image_src, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:body_html, :cost_per_item, :discount, :option1_name, :option1_value, :option2_name, :option2_value, :option3_name, :option3_value, :product_category, :published, :status, :title, :variant_barcode, :variant_inventory_qty, :variant_price, :variant_weight_unit, :vendor, :image_src])
    |> validate_required([:body_html, :cost_per_item, :discount, :option1_name, :option1_value, :option2_name, :option2_value, :option3_name, :option3_value, :product_category, :published, :status, :title, :variant_barcode, :variant_inventory_qty, :variant_price, :variant_weight_unit, :vendor, :image_src])
  end
end
