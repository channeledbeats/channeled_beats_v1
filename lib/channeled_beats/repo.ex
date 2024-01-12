defmodule ChanneledBeats.Repo do
  use Ecto.Repo,
    otp_app: :channeled_beats,
    adapter: Ecto.Adapters.Postgres
end
