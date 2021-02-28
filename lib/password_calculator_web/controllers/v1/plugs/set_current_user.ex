defmodule PasswordCalculatorWeb.V1.Plug.SetCurrentUser do
  import Plug.Conn

  def init(_), do: :ok

  def call(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :user, user)
  end
end
