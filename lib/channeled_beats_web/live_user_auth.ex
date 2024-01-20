defmodule ChanneledBeatsWeb.LiveUserAuth do
  import Phoenix.Component

  use ChanneledBeatsWeb, :verified_routes

  def on_mount(:live_user_optional, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:live_user_required, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:cont,
       Phoenix.LiveView.attach_hook(
         socket,
         :redirect_with_return_to,
         :handle_params,
         &redirect_with_return_to/3
       )}
    end
  end

  def on_mount(:live_no_user, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def redirect_with_return_to(_params, url, socket) do
    parts = URI.parse(url)

    return_to =
      if parts.query do
        parts.path <> "?" <> parts.query
      else
        parts.path
      end

    {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/create-account?return_to=#{return_to}")}
  end
end
