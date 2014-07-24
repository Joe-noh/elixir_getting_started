defmodule Stack do
  def start_link(initial_state) do
    {:ok, pid} = ok_pid = GenEvent.start_link()
    GenEvent.add_handler(pid, Stack.Handler, initial_state)
    ok_pid
  end

  def push(pid, item) do
    GenEvent.notify(pid, {:push, item})
  end

  def pop(pid) do
    GenEvent.call(pid, Stack.Handler, :pop)
  end
end
