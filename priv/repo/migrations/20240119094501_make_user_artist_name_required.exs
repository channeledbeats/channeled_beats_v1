defmodule ChanneledBeats.Repo.Migrations.MakeUserArtistNameRequired do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :artist_name, :citext, null: false
    end
  end

  def down do
    alter table(:users) do
      modify :artist_name, :citext, null: true
    end
  end
end