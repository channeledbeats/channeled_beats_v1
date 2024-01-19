defmodule ChanneledBeatsWeb.CreateAccountLive do
  use ChanneledBeatsWeb, :live_view

  # https://alembic.com.au/blog/customising-ash-authentication-with-phoenix-liveview

  def mount(_params, _session, socket) do
    form =
      AshPhoenix.Form.for_create(ChanneledBeats.Accounts.User, :register_with_password,
        api: ChanneledBeats.Accounts
      )
      |> to_form()

    {:ok, socket |> assign(:form, form)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    {:noreply, socket |> assign(:form, form)}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _user} ->
        ChanneledBeats.Accounts.User
        |> Ash.Query.for_read(:sign_in_with_password,
          email: params["email"],
          password: params["password"]
        )
        |> ChanneledBeats.Accounts.read!()
        |> IO.inspect()

        {:noreply,
         socket
         # TODO redirect to previously attempted url
         |> push_navigate(to: ~p"/")}

      {:error, form} ->
        form |> IO.inspect()
        {:noreply, socket}
    end
  end
end
