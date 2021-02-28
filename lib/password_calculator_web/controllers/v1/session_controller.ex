defmodule PasswordCalculatorWeb.V1.SessionController do
  use PasswordCalculatorWeb, :controller
  require Logger
  alias PasswordCalculator.Authentication.Guardian
  alias PasswordCalculator.Service.UserService
  alias PasswordCalculatorWeb.V1.Parameter.LoginParameter

  def login(conn, params) do
    changeset = LoginParameter.validate(params)

    if changeset.valid? do
      {:ok, %{user: %{email: email, password: password}}} =
        LoginParameter.from_changeset(changeset)

      login_reply(conn, UserService.authenticate_user(email, password))
    else
      respond_for_invalid_credentials(conn)
    end
  end

  defp login_reply(conn, {:ok, user}) do
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    conn
    |> json(%{message: :login_succeeded, token: jwt})
  end

  defp login_reply(conn, {:error, reason}) do
    Logger.info("Login reply failed. reason=#{inspect(reason)}.")
    respond_for_invalid_credentials(conn)
  end

  defp respond_for_invalid_credentials(conn) do
    conn
    |> put_status(401)
    |> json(%{message: :invalid_credentials})
  end
end
