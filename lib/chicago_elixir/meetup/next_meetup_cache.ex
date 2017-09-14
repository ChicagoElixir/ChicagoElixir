defmodule ChicagoElixir.Meetup.NextMeetupCache do
  use GenServer

  @interval 1 * 60 * 60 * 1000 # every hour
  @api Application.fetch_env!(:chicago_elixir, :meetup_api)
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
    schedule_fetch()
    data = @api.get!("events").body
    {:noreply, data}
  end

  def handle_call(:next_meetup, _from, []), do: {:reply, nil, []}
  def handle_call(:next_meetup, _from, state) do
    [next_meetup|_] = state

    meetup = %{
      time: meetup_time(next_meetup),
      title: next_meetup["name"],
      description: meetup_description(next_meetup),
      url: next_meetup["link"],
    }

    {:reply, meetup, state}
  end

  defp meetup_description(meetup) do
    HtmlSanitizeEx.basic_html(meetup["description"])
  end

  defp meetup_time(meetup) do
    time = meetup["time"]

    local_time = time
                 |> Timex.from_unix(:millisecond)
                 |> Timex.Timezone.convert("America/Chicago")


    formatted = Timex.format!(local_time, @time_format)
    relative = Timex.format!(local_time, "{relative}", :relative)
    "#{formatted} (#{relative})"
  end
end
