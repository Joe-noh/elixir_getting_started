defmodule Ppool.Supervisor do
  use Supervisor

  def start_link({name, limit, mfa}) do
    Supervisor.start_link(__MODULE__, [name, limit, mfa])
  end

  def init([name, limit, mfa]) do
    children = [
      worker(Ppool.Server,
             [name, limit, self, mfa],
             restart:  :permanent,
             shutdown: 5000,
             modules:  [Ppool.Server])
    ]

    supervise(children,
              strategy:     :one_for_all,
              max_restarts: 1,
              max_seconds:  3600)
  end
end
