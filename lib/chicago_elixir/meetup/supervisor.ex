defmodule ChicagoElixir.Meetup.Supervisor do
  use Supervisor

  alias ChicagoElixir.Meetup.NextMeetupCache

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    children = [
      worker(NextMeetupCache, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
