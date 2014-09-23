defmodule Curling.ScoreBoard do
  use GenEvent

  def init([]) do
    {:ok, []}
  end

  def handle_event({:set_teams, team_a, team_b}, state) do
    do_set_teams(team_a, team_b)
    {:ok, state}
  end

  def handle_event({:add_points, team, points}, state) do
    do_add_points(team, points)
    {:ok, state}
  end

  def handle_event(:next_round, state) do
    do_next_round
    {:ok, state}
  end

  defp do_set_teams(team_a, team_b) do
    IO.puts "Scoreboard: #{team_a} vs #{team_b}"
  end

  defp do_next_round do
    IO.puts "Scoreboard: round over"
  end

  defp do_add_points(team, 1) do
    IO.puts "Scoreboard: increased score of team #{team} by 1"
  end

  defp do_add_points(team, point) when point > 1 do
    IO.puts "Scoreboard: increased score of team #{team} by 1"
    do_add_points(team, point-1)
  end

  defp do_reset_board do
    IO.puts "Scoreboard: all teams are undefined and all scores are 0"
  end
end
