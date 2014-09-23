defmodule Curling do
  def set_teams(pid, team_a, team_b) do
    GenEvent.notify(pid, {:set_teams, team_a, team_b})
  end

  def next_round(pid) do
    GenEvent.notify(pid, :next_round)
  end

  def add_points(pid, team, points) do
    GenEvent.notify(pid, {:add_points, team, points})
  end
end
