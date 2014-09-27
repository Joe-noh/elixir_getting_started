defmodule Ppool do
  @doc """
       Ppool.SuperSupervisor
                 |
                 |
          Ppool.Supervisor
            /          \
           /            \
    Ppool.Server   Ppool.WorkerSupervisor
                     /                \
                    /                  \
               Ppool.Worker        Ppool.Worker
  """

  alias Ppool.SuperSupervisor, as: SupSup
  alias Ppool.Server

  def start_link do
    SupSup.start_link
  end

  def stop do
    SupSup.stop
  end

  def start_pool(name, limit, mfa) do
    SupSup.start_pool(name, limit, mfa)
  end

  def stop_pool(name) do
    SupSup.stop_pool(name)
  end

  def run(name, args) do
    Server.run(name, args)
  end

  def async_queue(name, args) do
    Server.async_queue(name, args)
  end

  def sync_queue(name, args) do
    Server.sync_queue(name, args)
  end
end
