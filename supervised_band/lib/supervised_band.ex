defmodule SupervisedBand do
  use Application

  def start(_type, manager) do
    import Supervisor.Spec, warn: false

    IO.puts "Our manager is #{manager}."

    Supervisor.start_link(children, opts(manager))
  end

  defp children do
    [
      {:singer,
       {SupervisedBand.Musician, :start_link, [:singer, :good]},
       :permanent,
       1000,
       :worker,
       [SupervisedBand.Musician]},

      {:bass,
       {SupervisedBand.Musician, :start_link, [:bass, :good]},
       :temporary,
       1000,
       :worker,
       [SupervisedBand.Musician]},

      {:drum,
       {SupervisedBand.Musician, :start_link, [:drum, :bad]},
       :transient,
       1000,
       :worker,
       [SupervisedBand.Musician]},

      {:keyter,
       {SupervisedBand.Musician, :start_link, [:keyter, :good]},
       :transient,
       1000,
       :worker,
       [SupervisedBand.Musician]}
    ]
  end

  defp opts(:lenient) do
    [
      name:         SupervisedBand.Supervisor,
      strategy:     :one_for_one,
      max_restarts: 3,
      max_seconds:  60,
    ]
  end

  defp opts(:angry) do
    [
      name:         SupervisedBand.Supervisor,
      strategy:     :rest_for_one,
      max_restarts: 2,
      max_seconds:  60,
    ]
  end

  defp opts(:jerk) do
    [
      name:         SupervisedBand.Supervisor,
      strategy:     :one_for_all,
      max_restarts: 1,
      max_seconds:  60,
    ]
  end
end
