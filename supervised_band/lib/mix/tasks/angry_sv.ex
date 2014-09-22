defmodule Mix.Tasks.AngrySV do
  use Mix.Task

  @shortdoc "Start to play with an angry supervisor"

  def run(_) do
    SupervisedBand.start(:normal, :angry)
    :timer.sleep :infinity
  end
end
