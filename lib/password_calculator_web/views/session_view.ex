defmodule PasswordCalculatorWeb.V1.SessionView do
  use PasswordCalculatorWeb, :view

  def render("login.json", %{jwt: jwt}) do
    %{
      message: "Login Succeeded!",
      jwt: jwt
    }
  end
end
