defmodule PasswordCalculator.Entity.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password, :string
    field :name, :string
    field :phone_number, :string
    field :base_key, :string
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
  end

  @required_fields ~w(
    email
    password
    name
    phone_number
    base_key
    inserted_at
    updated_at
  )a

  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email, name: :uq_email)
  end
end
