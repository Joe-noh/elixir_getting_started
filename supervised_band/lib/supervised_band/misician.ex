defmodule SupervisedBand.Musician do
  use GenServer
  alias SupervisedBand.Profile

  @delay 750

  def start_link(role, skill) do
    GenServer.start_link(__MODULE__, [role, skill], [name: role])
  end

  def stop(role) do
    GenServer.call(role, :stop)
  end

  def init([role, skill]) do
    Process.flag(:trap_exit, true)

    :random.seed(:os.timestamp())
    time_to_play = rand(1000, 3000)
    name = pick_name
    role_str = Atom.to_string(role)

    IO.puts "Musician #{name}, playing the #{role_str} entered the room."

    {:ok, %Profile{name: name, role: role_str, skill: skill}, time_to_play}
  end

  def handle_call(:stop, _from, player=%Profile{}) do
    {:stop, :normal, :ok, player}
  end

  def handle_call(_msg, _from, player) do
    {:noreply, player, @delay}
  end

  def handle_cast(_msg, player) do
    {:noreply, player, @delay}
  end

  def handle_info(:timeout, player=%Profile{name: name, skill: :good}) do
    IO.puts "#{name} produced sound!"
    {:noreply, player, @delay}
  end

  def handle_info(:timeout, player=%Profile{name: name, skill: :bad}) do
    case rand(1, 5) do
      1 ->
        IO.puts "#{name} produced false note. Uh oh"
        {:stop, :bad_note, player}
      _ ->
        IO.puts "#{name} produced sound!"
        {:noreply, player, @delay}
    end
  end

  def handle_info(_msg, player) do
    {:noreply, player, @delay}
  end

  def terminate(:normal, %Profile{name: name, role: role}) do
    IO.puts "#{name} left the room #{role}"
  end

  def terminate(:bad_note, %Profile{name: name, role: role}) do
    IO.puts "#{name} sucks! kicked that member out of the band! #{role}"
  end

  def terminate(:shutdown, %Profile{name: name}) do
    IO.puts "The manager is mad and fired the whole band!"
    IO.puts "#{name} just got back to playing in the subway"
  end

  def terminate(_reason, %Profile{name: name, role: role}) do
    IO.puts "#{name} has benn kicked out #{role}"
  end

  defp pick_name do
    Enum.at(first_names, rand(0, 9)) <> " " <> Enum.at(last_names, rand(0, 9))
  end

  defp first_names do
    ~w(Valerie Arnold Carlos Dorothy Keesha Phoebe Ralphie Tim Wanda Janet)
  end

  defp last_names do
    ~w(Frizzle Perlstein Ramon Ann Franklin Terese Tennelli Jamal Li Perlstein)
  end

  defp rand(min, max) when min < max do
    min_1 = min - 1
    :random.uniform(max - min_1) + min_1
  end
end
