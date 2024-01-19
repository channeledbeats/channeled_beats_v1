defmodule ChanneledBeatsWeb.CreateAccountLive do
  # https://alembic.com.au/blog/customising-ash-authentication-with-phoenix-liveview
  use ChanneledBeatsWeb, :live_view
  use ChanneledBeatsWeb.ValidateSubmit
  import ChanneledBeatsWeb.AddReturnTo

  def handle_params(params, _uri, socket) do
    [return_to_empty, add_return_to] = init_add_return_to(params)

    form =
      AshPhoenix.Form.for_action(ChanneledBeats.Accounts.User, :register_with_password,
        api: ChanneledBeats.Accounts,
        as: "user"
      )
      |> to_form()

    {:noreply,
     socket
     |> assign(:form, form)
     |> assign(:account_required, !return_to_empty)
     |> assign(:action, add_return_to.(~p"/auth/user/password/register"))
     |> assign(:sign_in_url, add_return_to.(~p"/sign-in"))
     |> assign(:trigger_action, false)}
  end
end
