defmodule Curling.Accumulator do
  use GenEvent
  alias Curling.Game

  def init([]) do
    {:ok, %Game{}}
  end

  def handle_event({:set_teams, team_a, team_b}, game) do
    teams = %{}
      |> Map.put_new(team_a, 0)
      |> Map.put_new(team_b, 0)

    {:ok, %Game{teams: teams}}
  end

  def handle_event({:add_points, team, points}, game) do
    teams = Map.update!(game.teams, team, &(&1 + points))
    {:ok, %Game{game | teams: teams}}
  end

  def handle_event(:next_round, game) do
    {:ok, %Game{game | round: game.round+1}}
  end

  def handle_call(:game_info, game = %Game{teams: teams, round: round}) do
    {:ok, {Map.to_list(teams), {:round, round}}, game}
  end
end
