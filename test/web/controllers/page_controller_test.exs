defmodule ChicagoElixir.Web.PageControllerTest do
  use ChicagoElixir.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Chicago's Elixir, Phoenix and Erlang Meetup"
  end
end
