defmodule PasswordCalculatorWeb.Router do
  use PasswordCalculatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PasswordCalculatorWeb do
    pipe_through :api
  end
end
