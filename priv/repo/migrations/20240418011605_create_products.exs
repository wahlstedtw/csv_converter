defmodule CsvConverter.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :body_html, :text
      add :cost_per_item, :float
      add :discount, :float
      add :option1_name, :string
      add :option1_value, :string
      add :option2_name, :string
      add :option2_value, :string
      add :option3_name, :string
      add :option3_value, :string
      add :product_category, :string
      add :published, :boolean, default: false, null: false
      add :status, :string
      add :title, :string
      add :variant_barcode, :string
      add :variant_inventory_qty, :integer
      add :variant_price, :float
      add :variant_weight_unit, :string
      add :vendor, :string
      add :image_src, :string

      timestamps(type: :utc_datetime)
    end
  end
end
