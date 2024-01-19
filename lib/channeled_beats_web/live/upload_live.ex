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
          ]
        ]
      )
      |> to_form()

    # form |> IO.inspect()

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:selected_collapsable, "fl-studio-tutorial")}
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
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    {:noreply, socket |> assign(:form, form)}
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
      <button id={"collapsable-" <> @name}
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
end
