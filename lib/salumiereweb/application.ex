defmodule Salumiereweb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SalumierewebWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:salumiereweb, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Salumiereweb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Salumiereweb.Finch},
      {Registry, keys: :unique, name: Cliente.Registry},
      {Registry, keys: :unique, name: Salumiere.Registry},
      # Start a worker by calling: Salumiereweb.Worker.start_link(arg)
      # {Salumiereweb.Worker, arg},
      # Start to serve requests, typically the last entry
      SalumierewebWeb.Endpoint,
      SalumiereClientiRegistry,
      SalSupervisor,
      ClienteSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Salumiereweb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SalumierewebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
