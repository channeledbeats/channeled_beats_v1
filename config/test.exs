import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :channeled_beats, ChanneledBeats.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "channeled_beats_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :channeled_beats, ChanneledBeatsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "0UeNvxLG1UO0pBDn3SYYva+T6z7IV7so4j/lwSOE2ah/fZWfGCjpheaoS26qcz1z",
  server: false

# In test we don't send emails.
config :channeled_beats, ChanneledBeats.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
