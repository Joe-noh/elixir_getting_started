defmodule AccumulatorTest do
  use ExUnit.Case
  alias Curling.Accumulator
  alias Curling.Game

  test "init" do
    assert Accumulator.init([]) == {:ok, %Game{}}
  end

  test "handle set_teams" do
    {:ok, game} = Accumulator.handle_event({:set_teams, "TeamA", "TeamB"}, %Game{})

    assert "TeamA" in Map.keys(game.teams)
    assert "TeamB" in Map.keys(game.teams)
    assert Map.values(game.teams) == [0, 0]
    assert game.round == 0
  end

  test "handle next_round" do
    {:ok, game} = Accumulator.handle_event(:next_round, %Game{})
    assert game.round == 1

    {:ok, game} = Accumulator.handle_event(:next_round, game)
    assert game.round == 2
  end

  test "handle game_info" do
    {:ok, {teams, {:round, round}}, _} = Accumulator.handle_call(:game_info, %Game{})

    assert teams == []
    assert round == 0

    game = %Game{teams: %{"TeamA" => 3, "TeamB" => 2}, round: 7}
    {:ok, {teams, {:round, round}}, _} = Accumulator.handle_call(:game_info, game)

    assert {"TeamA", 3} in teams
    assert {"TeamB", 2} in teams
    assert round == 7
  end
end
