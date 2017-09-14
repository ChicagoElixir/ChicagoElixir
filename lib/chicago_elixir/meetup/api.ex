defmodule ChicagoElixir.Meetup.Api do
  use HTTPoison.Base

  def process_url(url) do
    api_base_url()
    |> URI.merge(url)
    |> URI.to_string()
  end

  defp api_base_url() do
    Application.fetch_env!(:chicago_elixir, :meetup_api_url)
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end
end
