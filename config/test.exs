use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feedback, Feedback.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :feedback, Feedback.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "feedback_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure password hashing

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
