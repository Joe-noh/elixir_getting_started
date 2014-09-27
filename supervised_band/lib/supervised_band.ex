defmodule SupervisedBand do
  use Application

  def start(_type, manager) do
    IO.puts "Our manager is #{manager}."

    Supervisor.start_link(children, opts(manager))
  end

  defp children do
    import Supervisor.Spec, warn: false

    [
      worker(SupervisedBand.Musician,
             [:singer, :good],
             id: :singer,
             restart:  :permanent,
             shutdown: 1000,
             modules:  [SupervisedBand.Musician]),

      worker(SupervisedBand.Musician,
             [:bass, :good],
             id: :bass,
             restart:  :temporary,
             shutdown: 1000,
             modules:  [SupervisedBand.Musician]),

      worker(SupervisedBand.Musician,
             [:drum, :bad],
             id: :drum,
             restart:  :transient,
             shutdown: 1000,
             modules:  [SupervisedBand.Musician]),

      worker(SupervisedBand.Musician,
             [:keyter, :good],
             id: :keyter,
             restart:  :temporary,
             shutdown: 1000,
             modules:  [SupervisedBand.Musician])
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
