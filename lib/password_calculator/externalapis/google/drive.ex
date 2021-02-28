defmodule PasswordCalculator.ExternalAPI.Google.Drive do
  alias PasswordCalculator.ExternalAPI.Google.AccessToken

  @scopes "https://www.googleapis.com/auth/drive.file"
  @url "https://www.googleapis.com/drive/v3/files"

  def files() do
    case AccessToken.get(@scopes) do
      {:ok, access_token} ->
        url = build_url()
        headers = build_request_headers(access_token)
        HTTPoison.get(url, headers)

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_url do
    query_params = %{
      corpora: "allDrives",
      supportsAllDrives: true,
      includeItemsFromAllDrives: true,
      fields: "nextPageToken, files(id, name, webViewLink, mimeType)"
    }

    @url <> "?" <> URI.encode_query(query_params)
  end

  defp build_request_headers(access_token) do
    [{"Authorization", "Bearer #{access_token}"}]
  end
end
