defmodule PasswordCalculator.Service.PasswordService do
  alias PasswordCalculator.Entity.User
  alias PasswordCalculatorWeb.V1.Parameter.GeneratePasswordParameter

  @spec generate_password_for(User.t(), GeneratePasswordParameter.t()) :: String.t()
  def generate_password_for(user, params) do
    mix_into_master_key(params.base_key, user.master_key)
    |> make_hash_string()
    |> transform_case(params.case_type)
    |> exclude_symbols(params.include_symbols)
    |> exclude_alphabets_and_symbols(params.only_numeric)
    |> slice(params.length)
  end

  defp mix_into_master_key(base_key, master_key),
    do: base_key <> master_key

  defp make_hash_string(string),
    do: Base.encode64(:crypto.hash(:sha512, string))

  defp exclude_symbols(string, _include_symbols = true), do: string

  defp exclude_symbols(string, _include_symbols = false) do
    string
    |> String.replace("+", "")
    |> String.replace("/", "")
    |> String.replace("=", "")
  end

  defp exclude_alphabets_and_symbols(string, _only_numeric = false), do: string

  defp exclude_alphabets_and_symbols(string, _only_numeric = true) do
    string
    |> String.replace(~r/[a-zA-Z]/, "")
    |> exclude_symbols(false)
  end

  defp slice(string, length),
    do: String.slice(string, 0, length)

  defp transform_case(string, _case_type = :mix),
    do: string

  defp transform_case(string, _case_type = :upper),
    do: String.upcase(string)

  defp transform_case(string, _case_type = :lower),
    do: String.downcase(string)
end
