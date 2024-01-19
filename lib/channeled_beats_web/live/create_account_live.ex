defmodule ChanneledBeatsWeb.CreateAccountLive do
  use ChanneledBeatsWeb, :live_view

  # https://alembic.com.au/blog/customising-ash-authentication-with-phoenix-liveview

  def mount(_params, _session, socket) do
    form =
      AshPhoenix.Form.for_create(ChanneledBeats.Accounts.User, :register_with_password,
        api: ChanneledBeats.Accounts,
        as: "user"
      )
      |> to_form()

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:trigger_action, false)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, socket |> assign(:form, form)}
  end

  def handle_event("submit", %{"user" => params}, socket) do
    # TODO redirect to previously attempted url
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    {:noreply,
     socket
     |> assign(:form, form)
     |> assign(:trigger_action, form.source.valid?)}
  end
end
