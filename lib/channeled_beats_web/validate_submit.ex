defmodule ChanneledBeatsWeb.ValidateSubmit do
  defmacro __using__(_opts) do
    quote do
      def handle_event("validate", %{"user" => params}, socket) do
        form = AshPhoenix.Form.validate(socket.assigns.form, params)
        {:noreply, socket |> assign(:form, form)}
      end

      def handle_event("submit", %{"user" => params}, socket) do
        form = AshPhoenix.Form.validate(socket.assigns.form, params)

        {:noreply,
         socket
         |> assign(:form, form)
         |> assign(:trigger_action, form.source.valid?)}
      end
    end
  end
end
