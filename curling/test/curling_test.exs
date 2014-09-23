defmodule CurlingTest do
  use ExUnit.Case

  test "start_link" do
    {:ok, pid} = Curling.start_link("TeamA", "TeamB")

    assert is_pid(pid)
    assert Process.alive?(pid)
  end

  test "set_teams" do
    Curling.set_teams(self, "TeamA", "TeamB")
    assert_receive {:notify, {:set_teams, "TeamA", "TeamB"}}
  end

  test "next_round" do
    Curling.next_round(self)
    assert_receive {:notify, :next_round}
  end

  test "add_points" do
    Curling.add_points(self, "TeamA", 3)
    assert_receive {:notify, {:add_points, "TeamA", 3}}
  end

  test "join_feed" do
    {:ok, pid} = GenEvent.start_link
    {Curling.Feed, ref} = Curling.join_feed(pid, self)

    Curling.add_points(pid, "TeamA", 2)

    assert is_reference(ref)
    assert_receive {Curling.Feed, {:add_points, "TeamA", 2}}
  end

  test "leave_feed" do
    {:ok, pid} = GenEvent.start_link
    Curling.leave_feed(pid, Curling.join_feed(pid, self))

    Curling.add_points(pid, "TeamA", 2)

    refute_receive {Curling.Feed, {:add_points, "TeamA", 2}}
  end

  test "game_info" do
    {:ok, pid} = Curling.start_link("TeamA", "TeamB")

    {teams, {:round, round}} = Curling.game_info(pid)
    assert {"TeamA", 0} in teams
    assert {"TeamB", 0} in teams
    assert round == 0

    Curling.add_points(pid, "TeamA", 3)
    Curling.next_round pid
    Curling.next_round pid

    {teams, {:round, round}} = Curling.game_info(pid)
    assert {"TeamA", 3} in teams
    assert {"TeamB", 0} in teams
    assert round == 2
  end
end
