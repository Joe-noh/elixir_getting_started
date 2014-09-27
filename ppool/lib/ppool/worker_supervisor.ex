defmodule Ppool.WorkerSupervisor do
  use Supervisor

  def start_link(mfa = {_, _, _}) do
    Supervisor.start_link(__MODULE__, mfa)
  end

  def init(mfa = {module, _, _}) do
    children = [
      worker(Ppool.Worker,
             mfa,
             restart:  :temporary,
             shutdown: 5000,
             modules:  [module])
    ]

    supervise(children,
              strategy:     :simple_one_for_one,
              max_restarts: 5,
              max_seconds:  3600)
  end
end
