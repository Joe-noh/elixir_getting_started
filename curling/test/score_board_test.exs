defmodule ScoreBoardTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Curling.ScoreBoard

  test "init" do
    assert ScoreBoard.init([]) == {:ok, []}
  end

  test "handle set_teams" do
    handle = fn ->
      ScoreBoard.handle_event({:set_teams, "TeamA", "TeamB"}, [])
    end

    assert capture_io(handle) =~ "TeamA vs TeamB"
    assert handle.() == {:ok, []}
  end

  test "handle add_points" do
    handle = fn ->
      ScoreBoard.handle_event({:add_points, "TeamA", 3}, [])
    end

    assert capture_io(handle) =~ ~r/(.+by 1.+){3}/sm
    assert handle.() == {:ok, []}
  end

  test "handle next_round" do
    handle = fn ->
      ScoreBoard.handle_event(:next_round, [])
    end

    assert capture_io(handle) =~ "round over"
    assert handle.() == {:ok, []}
  end
end
