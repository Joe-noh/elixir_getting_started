defmodule Stack do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def push(pid, item) do
    GenServer.cast(pid, {:push, item})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, [h|t]) do
    return_value = h
    next_state   = t
    {:reply, return_value, next_state}
  end

  def handle_cast({:push, item}, current_state) do
    next_state = [item | current_state]
    {:noreply, next_state}
  end
end
