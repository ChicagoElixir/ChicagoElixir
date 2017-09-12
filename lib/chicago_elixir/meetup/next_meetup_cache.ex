defmodule ChicagoElixir.Meetup.NextMeetupCache do
  use GenServer

  @interval 2 * 60 * 60 * 1000 # every 2 hours
  @api Application.get_env(:chicago_elixir, :meetup_api)
  @time_format "{WDshort} {M}/{D} {h12}:{m}{am}"

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    fetch()
    {:ok, state}
  end

  def fetch() do
    GenServer.cast(pid(), :fetch)
  end

  def next_meetup() do
    GenServer.call(pid(), :next_meetup)
  end

  defp pid() do
    Process.whereis(__MODULE__)
  end

  defp schedule_fetch() do
    Process.send_after(self(), {:"$gen_cast", :fetch}, @interval)
  end

  # server

  def handle_cast(:fetch, _state) do
    data = @api.get!("events").body
    schedule_fetch()
    {:noreply, data}
  end

  def handle_call(:next_meetup, _from, state) do
    [next_meetup|_] = state

    meetup = %{
      time: meetup_time(next_meetup),
      title: next_meetup["name"],
      description: next_meetup["description"],
      url: next_meetup["link"],
    }

    {:reply, meetup, state}
  end

  defp meetup_time(meetup) do
    time = meetup["time"]

    if time do
      local_time = time
                   |> Timex.from_unix(:millisecond)
                   |> Timex.Timezone.convert("America/Chicago")


      formatted = Timex.format!(local_time, @time_format)
      relative = Timex.format!(local_time, "{relative}", :relative)
      "#{formatted} (#{relative})"
    else
      "TBD"
    end
  end
end
