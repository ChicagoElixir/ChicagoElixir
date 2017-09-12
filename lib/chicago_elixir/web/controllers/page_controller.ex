defmodule ChicagoElixir.Web.PageController do
  use ChicagoElixir.Web, :controller

  alias ChicagoElixir.Meetup.NextMeetupCache

  def index(conn, _params) do
    conn
    |> assign(:next_meetup, NextMeetupCache.next_meetup())
    |> render("index.html")
  end
end
