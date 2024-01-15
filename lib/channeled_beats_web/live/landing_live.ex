defmodule ChanneledBeatsWeb.LandingLive do
  use ChanneledBeatsWeb, :live_view

  def mount(params, session, socket) do
    beats = [
      %{name: "Beat 1", artist: "Artist 1", album: %{name: "Album 1"}},
      %{name: "Beat 2", artist: "Artist 1", album: %{name: "Album 2"}},
      %{name: "Beat 3", artist: "Artist 2", album: %{name: "Album 3"}}
    ]

    {:ok,
     socket
     |> assign(:beats, beats)
     |> assign(:user, session["user"])}
  end
end
