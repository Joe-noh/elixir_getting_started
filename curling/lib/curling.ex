defmodule Curling do
  def start_link(team_a, team_b) do
    {:ok, pid} = GenEvent.start_link

    GenEvent.add_handler(pid, Curling.ScoreBoard,  [])
    GenEvent.add_handler(pid, Curling.Accumulator, [])
    set_teams(pid, team_a, team_b)

    {:ok, pid}
  end

  def set_teams(pid, team_a, team_b) do
    GenEvent.notify(pid, {:set_teams, team_a, team_b})
  end

  def next_round(pid) do
    GenEvent.notify(pid, :next_round)
  end

  def add_points(pid, team, points) do
    GenEvent.notify(pid, {:add_points, team, points})
  end

  def join_feed(pid, feeder_pid) do
    handler_id = {Curling.Feed, make_ref}
    GenEvent.add_handler(pid, handler_id, [feeder_pid])
    handler_id
  end

  def leave_feed(pid, handler_id) do
    GenEvent.remove_handler(pid, handler_id, :leave_feed)
  end

  def game_info(pid) do
    GenEvent.call(pid, Curling.Accumulator, :game_info)
  end
end
