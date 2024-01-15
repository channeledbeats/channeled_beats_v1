defmodule ChanneledBeats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChanneledBeatsWeb.Telemetry,
      ChanneledBeats.Repo,
      {DNSCluster, query: Application.get_env(:channeled_beats, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChanneledBeats.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChanneledBeats.Finch},
      # Start a worker by calling: ChanneledBeats.Worker.start_link(arg)
      # {ChanneledBeats.Worker, arg},
      # Start to serve requests, typically the last entry
      ChanneledBeatsWeb.Endpoint,
      {AshAuthentication.Supervisor, otp_app: :channeled_beats}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChanneledBeats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChanneledBeatsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
