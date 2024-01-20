defmodule ChanneledBeats.MainApi do
  use Ash.Api

  resources do
    resource ChanneledBeats.MainApi.Beat
    resource ChanneledBeats.MainApi.Channel
    resource ChanneledBeats.MainApi.Album
  end
end
