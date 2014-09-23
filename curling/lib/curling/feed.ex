defmodule Curling.Feed do
  use GenEvent

  def init([pid]) do
    {:ok, pid}
  end

  def handle_event(event, pid) do
    send(pid, {Curling.Feed, event})
    {:ok, pid}
  end
end
