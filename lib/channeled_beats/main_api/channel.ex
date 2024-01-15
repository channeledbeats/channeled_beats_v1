defmodule ChanneledBeats.MainApi.Channel do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "channels"

    repo ChanneledBeats.Repo
  end

  attributes do
    uuid_primary_key(:id)

    attribute(:name, :string, allow_nil?: false)
    attribute(:extension, :string, allow_nil?: false)
  end

  relationships do
     belongs_to :beat, ChanneledBeats.MainApi.Beat 
  end
end
