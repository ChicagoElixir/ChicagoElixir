defmodule ChicagoElixir.Web.PageController do
  use ChicagoElixir.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
