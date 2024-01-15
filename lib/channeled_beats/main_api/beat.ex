defmodule ChanneledBeats.MainApi.Beat do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "beats"

    repo ChanneledBeats.Repo
  end

  attributes do
    uuid_primary_key(:id)

    attribute(:name, :string, allow_nil?: false)
    attribute(:remix_of_nolink, :string, allow_nil?: true)
  end

  relationships do
    has_many :channels, ChanneledBeats.MainApi.Channel
    belongs_to :artist, ChanneledBeats.Accounts.User do
      api ChanneledBeats.Accounts
    end
    belongs_to :remix_of, ChanneledBeats.MainApi.Beat do
      allow_nil? true
    end
  end
end
