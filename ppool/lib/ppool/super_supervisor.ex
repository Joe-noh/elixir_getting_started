defmodule Ppool.SuperSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def stop do
    case Process.whereis(Ppool) do
      pid when is_pid(pid) ->
        System.exit(pid, :kill)
      _ ->
        :ok
    end
  end

  def start_pool(name, limit, mfa) do
    child = supervisor(Ppool.Supervisor,
                       [{name, limit, mfa}],
                       restart:  :permanent,
                       shutdown: 10500,
                       modules:  [Ppool.Supervisor])

    Supervisor.start_child(__MODULE__, child)
  end

  def stop_pool(name) do
    Supervisor.terminate_child(__MODULE__, name)
    Supervisor.delete_child(__MODULE__, name)
  end

  def init([]) do
    supervise([],
              strategy:     :one_for_one,
              max_restarts: 6,
              max_seconds:  3600)
  end
end
