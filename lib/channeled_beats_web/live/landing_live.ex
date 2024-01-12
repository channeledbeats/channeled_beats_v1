defmodule ChanneledBeatsWeb.LandingLive do
  use ChanneledBeatsWeb, :live_view

  def mount(_params, _session, socket) do
    beats = [
      %{name: "Beat 1", artist: "Artist 1", album: %{name: "Album 1"}},
      %{name: "Beat 2", artist: "Artist 1", album: %{name: "Album 2"}},
      %{name: "Beat 3", artist: "Artist 2", album: %{name: "Album 3"}}
    ]

    {:ok, assign(socket, :beats, beats)}
  end
end
