defmodule ChanneledBeats.MainApi.Beat do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "beats"

    repo ChanneledBeats.Repo
  end

  actions do
    defaults [:read]

    create :create do
      argument(:channels, {:array, :map}, allow_nil?: false)
      argument(:artist, :map, allow_nil?: false)
      argument(:remix_of, :map, allow_nil?: true)

      change(manage_relationship(:channels, type: :create))
      change(manage_relationship(:artist, type: :append))
      change(manage_relationship(:remix_of, type: :append))
    end
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
      attribute_writable? true
    end

    belongs_to :remix_of, ChanneledBeats.MainApi.Beat do
      allow_nil? true
      attribute_writable? true
    end

    belongs_to :album, ChanneledBeats.MainApi.Album do
      allow_nil? false
      attribute_writable? true
    end
  end
end
