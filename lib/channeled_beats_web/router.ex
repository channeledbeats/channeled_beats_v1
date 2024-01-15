defmodule ChanneledBeatsWeb.Router do
  use ChanneledBeatsWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChanneledBeatsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  scope "/", ChanneledBeatsWeb do
    pipe_through :browser

    # live "/", LandingLive, :index

    sign_in_route register_path: "/create-account", reset_path: "/password-reset"
    sign_out_route AuthController
    auth_routes_for ChanneledBeats.Accounts.User, to: AuthController
    reset_route []

    ash_authentication_live_session :authentication_required,
      on_mount: {ChanneledBeatsWeb.LiveUserAuth, :live_user_required} do
      live "/user", LandingLive, :index
    end

    ash_authentication_live_session :authentication_optional,
      on_mount: {ChanneledBeatsWeb.LiveUserAuth, :live_user_optional} do
      live "/", LandingLive, :index
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:channeled_beats, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChanneledBeatsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
