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
      |> Map.put(:master_key, gen_master_key())
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

  # TODO: Impl
  def update(_) do
    :ok
  end

  @master_key_length 256
  defp gen_master_key do
    @master_key_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, @master_key_length)
  end
end
