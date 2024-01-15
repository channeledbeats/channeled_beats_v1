defmodule ChanneledBeats.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api ChanneledBeats.Accounts
  end

  postgres do
    table "tokens"
    repo ChanneledBeats.Repo
  end
end
