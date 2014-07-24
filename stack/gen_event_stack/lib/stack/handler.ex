defmodule Stack.Handler do
  use GenEvent

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_event({:push, item}, current_state) do
    next_state = [item|current_state]
    {:ok, next_state}
  end

  def handle_call(:pop, current_state) do
    case current_state do
      [] ->
        return_value = nil
        next_state   = []
        {:ok, return_value, next_state}
      [h|t] ->
        return_value = h
        next_state   = t
        {:ok, return_value, next_state}
    end
  end
end
