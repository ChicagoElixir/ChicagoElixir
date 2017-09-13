defmodule ChicagoElixir.Meetup.NextMeetupCacheTest do
  use ExUnit.Case, async: true

  alias ChicagoElixir.Meetup.NextMeetupCache

  describe ".next_meetup" do
    test "returns time in words for next meetup" do
      time = NextMeetupCache.next_meetup()[:time]
      assert time =~ "(in 1 day)"
    end

    test "returns the title for next meetup" do
      title = NextMeetupCache.next_meetup()[:title]
      assert title == "Elixir Hack Night"
    end

    test "returns a sanitized html description for next meetup" do
      description = NextMeetupCache.next_meetup()[:description]
      assert description == "<p>Come hack on Elixir();</p>"
    end

    test "returns the url for next meetup" do
      url = NextMeetupCache.next_meetup()[:url]
      assert url == "https://meetup.com/ChicagoElixir/events/1234"
    end
  end
end
