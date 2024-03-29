defmodule ChanneledBeats.Repo.Migrations.RenameArtistNameToUsername do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    rename table(:users), :artist_name, to: :username
  end

  def down do
    rename table(:users), :username, to: :artist_name
  end
end