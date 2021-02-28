defmodule PasswordCalculatorWeb.Router do
  use PasswordCalculatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PasswordCalculator.Authentication.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug PasswordCalculatorWeb.V1.Plug.SetCurrentUser
  end

  scope "/api/v1", PasswordCalculatorWeb.V1 do
    pipe_through [:api, :auth]

    post "/login", SessionController, :login
    post "/users", UserController, :create
  end

  scope "/api/v1", PasswordCalculatorWeb.V1 do
    pipe_through [:api, :auth, :ensure_auth]

    post "/password", PasswordController, :generate_password
  end
end
