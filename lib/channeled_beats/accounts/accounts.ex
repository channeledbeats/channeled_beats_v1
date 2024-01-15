defmodule ChanneledBeats.Accounts do
  use Ash.Api

  resources do
    resource ChanneledBeats.Accounts.User
    resource ChanneledBeats.Accounts.Token
  end
end
