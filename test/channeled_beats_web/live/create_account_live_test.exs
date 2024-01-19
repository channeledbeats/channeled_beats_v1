defmodule ChanneledBeatsWeb.CreateAccountLiveTest do
  use ChanneledBeatsWeb.ConnCase

  test "create account and sign in", _ do
    ChanneledBeats.Accounts.User
    |> Ash.Changeset.for_create(:register_with_password, %{
      email: "a@a.a",
      username: "aa",
      password: "asdfasdf",
      password_confirmation: "asdfasdf"
    })
    |> ChanneledBeats.Accounts.create!()

    

    # conn = get(conn, ~p"/")
    # assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
