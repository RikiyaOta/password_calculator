defmodule PasswordCalculator.Authentication.Guardian do
  use Guardian, otp_app: :password_calculator
  alias PasswordCalculator.Repository.UserRepository

  def subject_for_token(user, _claims) do
    {:ok, user.email}
  end

  def resource_from_claims(%{"sub" => email}) do
    case UserRepository.find_by_email(email) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
