# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vuechat,
  ecto_repos: [Vuechat.Repo]

# Configures the endpoint
config :vuechat, Vuechat.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1nou0rnmUl61y4T7NezGynQuA/NCaihmxXHfZPvYYxRx3OE6hn11hOCXOqxxU1/b",
  render_errors: [view: Vuechat.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Vuechat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
