defmodule PasswordCalculatorWeb.Router do
  use PasswordCalculatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", PasswordCalculatorWeb.V1 do
    pipe_through :api

    post "/users", UserController, :create
  end

end

