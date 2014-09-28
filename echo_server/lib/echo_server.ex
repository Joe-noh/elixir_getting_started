defmodule EchoServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Task, [EchoServer.Server, :start_link, [4000]])
    ]

    opts = [strategy: :one_for_one,
            max_restarts: 10,
            max_seconds:  60000,
            name: EchoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
