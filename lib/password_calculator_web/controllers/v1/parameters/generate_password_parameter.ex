defmodule PasswordCalculatorWeb.V1.Parameter.GeneratePasswordParameter do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias PasswordCalculatorWeb.V1.Parameter.ParameterBehaviour

  @behaviour ParameterBehaviour

  @primary_key false
  embedded_schema do
    field :base_key, :string
    field :include_symbols, :boolean, default: true
    field :length, :integer, default: 12
    field :only_numeric, :boolean, default: false
    field :case_type, Ecto.Enum, values: [:mix, :upper, :lower], default: :mix
  end

  @required_fields ~w(
    base_key
    length
    include_symbols
    only_numeric
    case_type
  )a

  @optional_fields ~w(
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
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length()
  end

  @min_password_length 3
  @max_password_length 30
  defp validate_length(changeset) do
    validate_number(changeset, :length,
      greater_than: @min_password_length - 1,
      less_than: @max_password_length + 1
    )
  end
end
