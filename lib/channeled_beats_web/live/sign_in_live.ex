defmodule ChanneledBeatsWeb.SignInLive do
  # https://alembic.com.au/blog/customising-ash-authentication-with-phoenix-liveview
  use ChanneledBeatsWeb, :live_view
  use ChanneledBeatsWeb.ValidateSubmit
  import ChanneledBeatsWeb.AddReturnTo

  def mount(params, _session, socket) do
    [return_to_empty, add_return_to] = init_add_return_to(params)
    
    form =
      AshPhoenix.Form.for_action(ChanneledBeats.Accounts.User, :sign_in_with_password,
        api: ChanneledBeats.Accounts,
        as: "user"
      )
      |> to_form()

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:account_required, !return_to_empty)
     |> assign(:action, add_return_to.(~p"/auth/user/password/sign_in"))
     |> assign(:create_account_url, add_return_to.(~p"/create-account"))
     |> assign(:trigger_action, false)}
  end
end
