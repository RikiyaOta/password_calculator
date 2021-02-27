defmodule PasswordCalculator.Repository.UserRepository do
  alias PasswordCalculator.Entity.User
  alias PasswordCalculator.Repo
  alias PasswordCalculatorWeb.V1.Parameter.CreateUserParameter

  def find_by_email(email), do: Repo.get_by(User, email: email)

  def create(%CreateUserParameter{} = params) do
    now = DateTime.utc_now()

    params =
      params
      |> CreateUserParameter.to_map()
      |> Map.put(:base_key, gen_base_key())
      |> Map.put(:inserted_at, now)
      |> Map.put(:updated_at, now)

    %User{}
    |> User.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, _} -> :ok
      error -> error
    end
  end

  @base_key_length 512
  defp gen_base_key do
    @base_key_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, @base_key_length)
  end
end
