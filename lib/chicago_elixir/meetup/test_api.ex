defmodule ChicagoElixir.Meetup.TestApi do
  def get!("events") do
    %{
      body: [
        %{
          "time" => tomorrow_unix_time(),
          "name" => "Elixir Hack Night",
          "description" => "Come hack on Elixir",
          "link" => "https://meetup.com/ChicagoElixir/events/1234",
        }
      ]
    }
  end

  defp tomorrow_unix_time() do
    DateTime.utc_now()
    |> Timex.shift(days: 1, hours: 1)
    |> Timex.to_unix()
    |> Kernel.*(1000)
  end
end
