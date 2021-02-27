defmodule PasswordCalculatorWeb.V1.Parameter.UserParameter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :email, :string
    field :password, :string
    field :name, :string
    field :phone_number, :string
  end

  @required_fields ~w(
    email
    password
    name
    phone_number
  )a

  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

end
