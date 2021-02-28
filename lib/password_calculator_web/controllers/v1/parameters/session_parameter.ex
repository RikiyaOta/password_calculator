defmodule PasswordCalculatorWeb.V1.Parameter.LoginParameter do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias PasswordCalculatorWeb.V1.Parameter.LoginParameter.UserParameter

  defmodule UserParameter do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :email, :string
      field :password, :string
    end

    @required_fields ~w(
      email
      password
    )a

    def changeset(%__MODULE__{} = struct, params) do
      struct
      |> cast(params, @required_fields)
      |> validate_required(@required_fields)
    end

    def from_changeset(%Changeset{valid?: true, changes: changes}),
      do: {:ok, struct(__MODULE__, changes)}
  end

  @primary_key false
  embedded_schema do
    embeds_one :user, UserParameter
  end

  def validate(params), do: changeset(%__MODULE__{}, params)

  def to_map(%__MODULE__{} = struct), do: Map.from_struct(struct)

  def from_changeset(%Changeset{valid?: true, changes: changes}) do
    {:ok, user} = UserParameter.from_changeset(changes.user)

    {:ok, struct(__MODULE__, %{user: user})}
  end

  def from_changeset(changeset), do: {:error, {:invalid_input, changeset}}

  defp changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, [])
    |> cast_embed(:user,
      required: true,
      with: &UserParameter.changeset/2
    )
  end
end
