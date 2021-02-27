defmodule PasswordCalculatorWeb.V1.UserController do
  use PasswordCalculatorWeb, :controller
  require Logger
  alias PasswordCalculator.Repository.UserRepository
  alias PasswordCalculatorWeb.V1.Parameter.CreateUserParameter

  def create(conn, params) do
    changeset = CreateUserParameter.validate(params)

    if changeset.valid? do
      {:ok, params} = CreateUserParameter.from_changeset(changeset)

      case UserRepository.create(params) do
        :ok ->
          json(conn, %{message: :ok})

        {:error, changeset} ->
          conn
          |> put_status(400)
          |> json(%{errors: inspect(changeset.errors)})
      end
    else
      json(conn, %{message: :error})
    end
  end
end
