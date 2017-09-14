defmodule ChicagoElixir.Meetup.NextMeetupCacheTest do
  use ExUnit.Case, async: true

  alias ChicagoElixir.Meetup.NextMeetupCache

  setup do
    bypass = Bypass.open(port: 8080)
    Application.put_env(:chicago_elixir, :meetup_api_url, "http://localhost:8080")
    {:ok, bypass: bypass}
  end

  defp tomorrow_unix_timestamp() do
    DateTime.utc_now()
    |> Timex.shift(days: 1, hours: 1)
    |> Timex.to_unix()
    |> Kernel.*(1000)
  end

  defp meetup_exists_response() do
    Poison.encode!([%{
      time: tomorrow_unix_timestamp(),
      name: "Elixir Hack Night",
      description:  "<p>Come hack on <script>Elixir();</script></p>",
      link: "https://meetup.com/ChicagoElixir/events/1234",
    }])
  end

  defp no_meetups_response() do
    Poison.encode!([])
  end

  defp fetch_events(bypass, response) do
    Bypass.expect_once bypass, "GET", "/events", fn conn ->
      Plug.Conn.resp(conn, 200, response)
    end

    NextMeetupCache.fetch()
  end

  describe ".next_meetup" do
    test "returns time in words for next meetup", %{bypass: bypass} do
      fetch_events(bypass, meetup_exists_response())
      time = NextMeetupCache.next_meetup()[:time]
      assert time =~ "(in 1 day)"
    end

    test "returns the title for next meetup", %{bypass: bypass} do
      fetch_events(bypass, meetup_exists_response())
      title = NextMeetupCache.next_meetup()[:title]
      assert title == "Elixir Hack Night"
    end

    test "returns a sanitized html description for next meetup", %{bypass: bypass} do
      fetch_events(bypass, meetup_exists_response())
      description = NextMeetupCache.next_meetup()[:description]
      assert description == "<p>Come hack on Elixir();</p>"
    end

    test "returns the url for next meetup", %{bypass: bypass} do
      fetch_events(bypass, meetup_exists_response())
      url = NextMeetupCache.next_meetup()[:url]
      assert url == "https://meetup.com/ChicagoElixir/events/1234"
    end

    test "returns time as 'TBD' if no meetups exist", %{bypass: bypass} do
      fetch_events(bypass, no_meetups_response())
      next_meetup = NextMeetupCache.next_meetup()
      assert next_meetup == nil
    end
  end
end
