defmodule CsvConverter.Repo do
  use Ecto.Repo,
    otp_app: :csv_converter,
    adapter: Ecto.Adapters.Postgres
end
