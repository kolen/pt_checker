# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pt_checker,
  ecto_repos: [PtChecker.Repo]

# Configures the endpoint
config :pt_checker, PtCheckerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xuGiC1b8YcuPY0zk7pwXiM5cPXvEwHk0mtCxAYXwOyatibrlmTOecNgaw98U93vF",
  render_errors: [view: PtCheckerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PtChecker.PubSub,
  live_view: [signing_salt: "stQCOd8w"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
