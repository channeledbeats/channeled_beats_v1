defmodule ChanneledBeatsWeb.AddReturnTo do
  def empty, do: [true, fn url -> url end]

  def init_add_return_to(%{"return_to" => ""}), do: empty()
  def init_add_return_to(%{"return_to" => nil}), do: empty()

  def init_add_return_to(%{"return_to" => return_to}),
    do: [false, fn url -> url <> "?" <> URI.encode_query(%{return_to: return_to}) end]
end
