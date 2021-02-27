defmodule PasswordCalculator.Entity.EctoSchemaHelper do
  def to_map(schema) do
    schema
    |> Map.from_struct()
    |> Map.delete(:__meta__)
  end
end
