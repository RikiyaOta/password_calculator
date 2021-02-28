defmodule PasswordCalculatorWeb.V1.PasswordController do
  use PasswordCalculatorWeb, :controller
  alias PasswordCalculatorWeb.V1.Parameter.GeneratePasswordParameter
  alias PasswordCalculator.Service.PasswordService

  def generate_password(conn, params) do
    changeset = GeneratePasswordParameter.validate(params)

    if changeset.valid? do
      user = conn.assigns.user
      {:ok, generate_passoword_params} = GeneratePasswordParameter.from_changeset(changeset)

      render(conn, "generate_password.json",
        generated_password: PasswordService.generate_password_for(user, generate_passoword_params)
      )
    else
      conn
      |> put_status(400)
      |> json(%{status: 400, title: "Invalid parameters."})
    end
  end
end
