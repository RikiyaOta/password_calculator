defmodule PasswordCalculator.Service.UserService do
  alias PasswordCalculator.Entity.User
  alias PasswordCalculator.Repository.UserRepository

  @spec authenticate_user(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :invalid_credentials}
  def authenticate_user(email, plain_password) do
    case UserRepository.find_by_email(email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :user_not_found_by_email}

      user ->
        if Argon2.verify_pass(plain_password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_password}
        end
    end
  end
end
