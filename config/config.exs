# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :password_calculator,
  ecto_repos: [PasswordCalculator.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :password_calculator, PasswordCalculatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "60tKsws0WxHSIrG7w/FDefUTCWRXFf5Hvp1tZrQqVoqtQq03rHmMKfl9hVrZ4mMO",
  render_errors: [view: PasswordCalculatorWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PasswordCalculator.PubSub,
  live_view: [signing_salt: "nBw2N/Y2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
