defmodule PasswordCalculator.Repo do
  use Ecto.Repo,
    otp_app: :password_calculator,
    adapter: Ecto.Adapters.Postgres
end
