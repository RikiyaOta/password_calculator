defmodule PasswordCalculatorWeb.V1.PasswordView do
  use PasswordCalculatorWeb, :view

  def render("generate_password.json", %{generated_password: generated_password}) do
    %{
      message: "Password Generation Succeeded!",
      password: generated_password
    }
  end
end
