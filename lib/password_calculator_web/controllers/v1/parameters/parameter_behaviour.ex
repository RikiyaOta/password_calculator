defmodule PasswordCalculatorWeb.V1.Parameter.ParameterBehaviour do
  alias Ecto.Changeset
  @callback validate(map()) :: Changeset.t()
  @callback to_map(struct()) :: map()
  @callback from_changeset(Changeset.t()) ::
              {:ok, struct()} | {:error, {:invalid_input, Changeset.t()}}
end
