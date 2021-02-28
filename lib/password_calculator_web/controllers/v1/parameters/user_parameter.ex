defmodule PasswordCalculatorWeb.V1.Parameter.CreateUserParameter do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias PasswordCalculatorWeb.V1.Parameter.ParameterBehaviour

  @behaviour ParameterBehaviour

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

  @impl ParameterBehaviour
  def validate(params), do: changeset(%__MODULE__{}, params)

  @impl ParameterBehaviour
  def to_map(%__MODULE__{} = struct), do: Map.from_struct(struct)

  @impl ParameterBehaviour
  def from_changeset(%Changeset{valid?: true, changes: changes}),
    do: {:ok, struct(__MODULE__, changes)}

  def from_changeset(changeset), do: {:error, {:invalid_input, changeset}}

  defp changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_email()
    |> validate_password_length()
    |> validate_phone_number()
  end

  defp validate_email(%Changeset{} = changeset) do
    email_format = ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
    validate_format(changeset, :email, email_format)
  end

  defp validate_password_length(%Changeset{} = changeset),
    do: validate_length(changeset, :password, min: 6)

  defp validate_phone_number(%Changeset{} = changeset) do
    phone_number_format = ~r/^0\d{9,10}$/
    validate_format(changeset, :phone_number, phone_number_format)
  end
end
