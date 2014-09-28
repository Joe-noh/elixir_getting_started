defmodule Ppool.Server do
  use GenServer

  defmodule State do
    defstruct limit: 0, sup: nil, refs: nil, queue: []
  end

  def start(name, limit, pool_sup, mfa) when is_atom(name) and is_integer(limit) do
    GenServer.start(__MODULE__, {limit, mfa, pool_sup}, name: name)
  end

  def start_link(name, limit, pool_sup, mfa) when is_atom(name) and is_integer(limit) do
    GenServer.start_link(__MODULE__, {limit, mfa, pool_sup}, name: name)
  end

  def run(name, args) do
    GenServer.call(name, {:run, args})
  end

  def sync_queue(name, args) do
    GenServer.call(name, {:sync, args}, :infinity)
  end

  def async_queue(name, args) do
    GenServer.cast(name, {:async, args})
  end

  def stop(name) do
    GenServer.stop(name, :stop)
  end

  defp spec(mfa) do
    Supervisor.Spec.supervisor(Ppool.WorkerSupervisor,
                               [mfa],
                               restart:  :temporary,
                               shutdown: 10000,
                               modules:  [Ppool.WorkerSupervisor])
  end

  def init({limit, mfa, worker_sup}) do
    send(self, {:start_worker_sup, worker_sup, mfa})
    {:ok, %State{limit: limit, refs: HashSet.new}}
  end

  def handle_call({:run, args}, _from, state = %State{limit: limit, sup: sup, refs: refs}) when limit > 0 do
    {:ok, pid} = Supervisor.start_child(sup, args)
    ref = Process.monitor(pid)
    {:reply, {:ok, pid}, %State{state | limit: limit-1, refs: HashSet.put(refs, ref)}}
  end

  def handle_call({:run, _}, _, state = %State{}) do
    {:reply, :noalloc, state}
  end

  def handle_call({:sync, args}, _from, state = %State{limit: limit, sup: sup, refs: refs}) when limit > 0 do
    {:ok, pid} = Supervisor.start_child(sup, args)
    ref = Process.monitor(pid)
    {:reply, {:ok, pid}, %State{state | limit: limit-1, refs: HashSet.put(refs, ref)}}
  end

  def handle_call({:sync, args}, from, state = %State{queue: queue}) do
    {:noreply, %State{state | queue: [{from, args} | queue]}}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_cast({:async, args}, state = %State{limit: limit, sup: sup, refs: refs}) when limit > 0 do
    {:ok, pid} = Supervisor.start_child(sup, args)
    ref = Process.monitor(pid)
    {:noreply, %State{state | limit: limit-1, refs: HashSet.put(refs, ref)}}
  end

  def handle_cast({:async, args}, state = %State{queue: queue}) do
    {:noreply, %State{state | queue: [args | queue]}}
  end

  def handle_info({:start_worker_sup, worker_sup, mfa}, state) do
    {:ok, pid} = Supervisor.start_child(worker_sup, spec(mfa))
    Process.link(pid)
    {:noreply, %State{state | sup: pid}}
  end

  def handle_info({:DOWN, ref, _process, _pid, _}, state = %State{refs: refs}) do
    if HashSet.member?(refs, ref) do
      handle_down_worker(ref, state)
    else
      {:noreply, state}
    end
  end

  defp handle_down_worker(ref, state = %State{limit: limit, refs: refs, queue: []}) do
    {:noreply, %State{state | limit: limit+1, refs: HashSet.delete(refs, ref)}}
  end

  defp handle_down_worker(ref, state = %State{limit: limit, sup: sup, refs: refs, queue: queue}) do
    [head | rest] = Enum.reverse(queue)
    case head do
      {from, args} ->
        {:ok, pid} = Supervisor.start_child(sup, args)
        new_refs = refs |> HashSet.delete(ref) |> HashSet.put(Process.monitor pid)
        GenServer.reply(from, {:ok, pid})
        {:noreply, %State{state | refs: new_refs, queue: Enum.reverse(rest)}}
      args ->
        {:ok, pid} = Supervisor.start_child(sup, args)
        new_refs = refs |> HashSet.delete(ref) |> HashSet.put(Process.monitor pid)
        {:noreply, %State{state | refs: new_refs, queue: Enum.reverse(rest)}}
    end
  end
end
