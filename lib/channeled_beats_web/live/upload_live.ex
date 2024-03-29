defmodule ChanneledBeatsWeb.UploadLive do
  use ChanneledBeatsWeb, :live_view

  def mount(_params, _session, socket) do
    form =
      AshPhoenix.Form.for_create(ChanneledBeats.MainApi.Beat, :create,
        api: ChanneledBeats.MainApi,
        forms: [
          # auto?: true,
          artist: [
            resource: ChanneledBeats.Accounts.User,
            data: socket.assigns.current_user,
            update_action: :update,
            type: :single
          ],
          album: [
            resource: ChanneledBeats.MainApi.Album,
            # data: %{name: ""},
            create_action: :create,
            # update_action: :update,
            type: :single
          ]
        ]
      )
      |> AshPhoenix.Form.add_form(:album)
      |> to_form()

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:beat_name_done, false)
     |> assign(:album_done, false)
     |> assign(:remix_type, "not")
     |> assign(:selected_collapsable, "fl-studio-tutorial")
     |> allow_upload(:album_cover, accept: ~w(image/*), max_entries: 1)
     |> allow_upload(:channels, accept: ~w(audio/*), max_entries: 256)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("remove-album-cover", _params, socket) do
    ref = Enum.at(socket.assigns.uploads.album_cover.entries, 0).ref

    {:noreply,
     socket
     |> assign(:album_done, false)
     |> cancel_upload(:album_cover, ref)}
  end

  def handle_event("select-collapsable", %{"name" => name}, socket) do
    # Deselect a collapsable if it was already selected 
    name =
      if name == socket.assigns.selected_collapsable do
        ""
      else
        name
      end

    {:noreply, socket |> assign(:selected_collapsable, name)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    params = augment_params(params, socket)

    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    {:noreply,
     socket
     |> assign(:form, form)
     |> assign(
       :beat_name_done,
       MapSet.member?(form.source.touched_forms, "name") && !form.errors[:name]
     )
     |> assign(
       :album_done,
       form.source.forms.album.source.valid? && socket.assigns.uploads.album_cover.entries != []
     )}
  end

  def handle_event("select-remix-type", %{"type" => type}, socket) do
    {:noreply, socket |> assign(:remix_type, type)}
  end

  def handle_event("remove-channel", %{"entry" => entry}, socket) do
    {:noreply, socket |> cancel_upload(:channels, entry)}
  end

  def augment_params(params, socket) do
    album_cover = Enum.at(socket.assigns.uploads.album_cover.entries, 0)

    extension =
      if album_cover do
        Path.extname(album_cover.client_name)
      else
        nil
      end

    params
    |> put_in(["album", "extension"], extension)
  end

  def remix_type(assigns) do
    # assigns =
    # 	assigns
    # 	|> assign(:

    ~H"""
    <div
      class={[
        "p-4 select-none",
        if @selected == @type do
          "text-gray-500 bg-zinc-200"
        else
          "cursor-pointer"
        end
      ]}
      phx-click="select-remix-type"
      phx-value-type={@type}
    >
      <%= @label %>
    </div>
    """
  end

  def collapsable(assigns) do
    assigns =
      assigns
      |> assign(:disabled, assigns[:disabled] == true)
      |> assign(:selected, assigns.name == assigns.selected_collapsable)
      |> assign(
        :icon_name,
        if assigns.done do
          "hero-check-circle"
        else
          "hero-exclamation-circle"
        end
      )
      |> assign(
        :icon_color,
        if assigns.done do
          "text-good"
        else
          "text-warning"
        end
      )

    ~H"""
    <div>
      <button
        id={"collapsable-" <> @name}
        type="button"
        disabled={
          if @disabled do
            true
          else
            false
          end
        }
        class={["block w-full py-6 px-4 text-xl font-bold flex", @selected && "bg-zinc-200"]}
        phx-click="select-collapsable"
        phx-value-name={@name}
      >
        <div class={["grow", @disabled && "text-zinc-300"]}><%= @label %></div>
        <span class={[@icon_color, @disabled && "hidden"]}>
          <.icon name={@icon_name} class="h-8 w-8" />
        </span>
      </button>
      <div class={!@selected && "hidden"}><%= render_slot(@inner_block) %></div>
    </div>
    """
  end

  def channel(assigns) do
   assigns.entry |> IO.inspect()

   ~H"""
   <div class="p-4 my-4 border border-zinc-300 rounded-lg flex justify-between">
   		<div><%= Path.rootname(@entry.client_name) %></div>
   		<div class="cursor-pointer" phx-click="remove-channel" phx-value-entry={@entry.ref}>
   			<.icon name="hero-x-circle" class="h-7 w-7 mt-[-5px]" />
   		</div>
   </div>
   """
  end
end
