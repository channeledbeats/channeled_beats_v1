defmodule ChanneledBeatsWeb.UploadLive do
  use ChanneledBeatsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:selected_collapsable, "fl-studio-tutorial")}
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

  def collapsable(assigns) do
    icon_name =
      if assigns.done do
        "hero-check-circle"
      else
        "hero-exclamation-circle"
      end

    icon_color =
      if assigns.done do
        "text-good"
      else
        "text-warning"
      end

    selected = assigns.name == assigns.selected_collapsable

    title_bg_color =
      if selected do
        "bg-zinc-200"
      else
        ""
      end

    ~H"""
    <div>
      <button
        type="button"
        class={["block w-full py-6 px-4 text-xl font-bold flex", title_bg_color]}
        phx-click="select-collapsable"
        phx-value-name={@name}
      >
        <div class="grow"><%= @label %></div>
        <.icon
          name={icon_name}
          class={[
            "h-8 w-8",
            icon_color
          ]}
        />
      </button>
      <div class={!selected && "hidden"}><%= render_slot(@inner_block) %></div>
    </div>
    """
  end
end
