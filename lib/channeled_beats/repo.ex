defmodule ChanneledBeats.Repo do
  use AshPostgres.Repo,
    otp_app: :channeled_beats

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
