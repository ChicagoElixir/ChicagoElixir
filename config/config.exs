# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chicago_elixir,
  ecto_repos: [ChicagoElixir.Repo]

# Configures the endpoint
config :chicago_elixir, ChicagoElixir.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bCOEmzN+5ZDuc2NnE1ZHY+3SLLiJ5M9IjJh8htW/HACMMDiG5kTkPRG7s3/3S79V",
  render_errors: [view: ChicagoElixir.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChicagoElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :chicago_elixir, :meetup_api, ChicagoElixir.Meetup.Api

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
