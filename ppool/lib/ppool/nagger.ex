defmodule Ppool.Nagger do
  use GenServer

  def start_link(task, delay, max, send_to) do
    GenServer.start_link(__MODULE__, {task, delay, max, send_to}, [])
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def init(tdms = {_task, delay, _max, _send_to}) do
    {:ok, tdms, delay}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_info(:timeout, {task, delay, max, send_to}) do
    send(send_to, {self, task})
    cond do
      max == :infinity ->
        {:noreply, {task, delay, max, send_to}, delay}
      max <= 1 ->
        {:stop, :normal, {task, delay, 0, send_to}}
      max > 1 ->
        {:noreply, {task, delay, max-1, send_to}, delay}
    end
  end
end
