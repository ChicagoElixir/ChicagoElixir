defmodule ChicagoElixir.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(ChicagoElixir.Repo, []),
      supervisor(ChicagoElixir.Web.Endpoint, []),
      worker(ChicagoElixir.Meetup.Supervisor, []),
    ]

    opts = [strategy: :one_for_one, name: ChicagoElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
