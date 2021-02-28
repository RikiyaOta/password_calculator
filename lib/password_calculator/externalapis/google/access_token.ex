defmodule PasswordCalculator.ExternalAPI.Google.AccessToken do
  use Timex

  @project_root_dir Application.get_env(:password_calculator, :project_root_dir)
  @secret_relative_dir Application.get_env(:password_calculator, :secret_relative_dir)
  @alg "RS256"

  def get(scopes) do
    file_path = secret_key_file_path()

    with {:ok, secret_key_file_content} <- read_secret_key_file(file_path),
         service_account_email = Map.get(secret_key_file_content, "client_email"),
         secret_key_pem = Map.get(secret_key_file_content, "private_key"),
         jwt_claim = build_jwt_claim(service_account_email, scopes),
         {:ok, jwt} <- sign_jwt(jwt_claim, secret_key_pem),
         {:ok, access_token} <- request_access_token(jwt) do
      {:ok, access_token}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp read_secret_key_file(file_path) do
    case File.read(file_path) do
      {:ok, content} -> Jason.decode(content)
      {:error, _} = error -> error
    end
  end

  defp secret_key_file_path do
    Path.join([
      @project_root_dir,
      @secret_relative_dir,
      "google/password-calculator-authentication.json"
    ])
  end

  defp build_jwt_claim(service_account_email, scopes) do
    now = Timex.now()
    expired_at = Timex.shift(now, hours: 1)

    %{
      "iss" => service_account_email,
      "scope" => scopes,
      "aud" => "https://oauth2.googleapis.com/token",
      "exp" => Timex.to_unix(expired_at),
      "iat" => Timex.to_unix(now)
    }
  end

  defp sign_jwt(jwt_claim, secret_key) do
    signer = Joken.Signer.create(@alg, %{"pem" => secret_key})

    case Joken.encode_and_sign(jwt_claim, signer) do
      {:ok, jwt, _claim} -> {:ok, jwt}
      {:error, _reason} = error -> error
    end
  end

  defp request_access_token(jwt) do
    url = "https://oauth2.googleapis.com/token"
    grant_type = "urn:ietf:params:oauth:grant-type:jwt-bearer"
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    body =
      {:form,
       [
         {"grant_type", grant_type},
         {"assertion", jwt}
       ]}

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        access_token = body |> Jason.decode!() |> Map.get("access_token")
        {:ok, access_token}

      {:ok, response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end
end
