defmodule Mix.Tasks.JerkSV do
  use Mix.Task

  @shortdoc "Start to play with a jerk supervisor"

  def run(_) do
    SupervisedBand.start(:normal, :jerk)
    :timer.sleep :infinity
  end
end
