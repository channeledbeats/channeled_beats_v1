defmodule ChanneledBeats.MainApi.Album do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "albums"

    repo ChanneledBeats.Repo
  end

  actions do
    defaults [:read, :create, :update]
  end

  attributes do
    uuid_primary_key(:id)

    attribute(:name, :string, allow_nil?: false)
    attribute(:extension, :string, allow_nil?: false)
  end

  relationships do
    has_many :beats, ChanneledBeats.MainApi.Beat
  end
end
