defmodule ChanneledBeats.Accounts.SendPasswordResetEmail do
  use AshAuthentication.Sender
  use ChanneledBeatsWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _) do
    ChanneledBeats.Accounts.Emails.deliver_reset_password_instructions(
      user,
      url(~p"/password-reset/#{token}")
    )
  end
end
