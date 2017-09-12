defmodule ChicagoElixir.Meetup.Api do
  use HTTPoison.Base

  def process_url(url) do
    "https://api.meetup.com/ChicagoElixir/" <> url
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end
end
