defmodule CurlingTest do
  use ExUnit.Case

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
end
