defmodule CsvConverter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CsvConverterWeb.Telemetry,
      CsvConverter.Repo,
      {DNSCluster, query: Application.get_env(:csv_converter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CsvConverter.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CsvConverter.Finch},
      # Start a worker by calling: CsvConverter.Worker.start_link(arg)
      # {CsvConverter.Worker, arg},
      # Start to serve requests, typically the last entry
      CsvConverterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CsvConverter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CsvConverterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
