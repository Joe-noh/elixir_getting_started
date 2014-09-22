defmodule Mix.Tasks.LenientSV do
  use Mix.Task

  @shortdoc "Start to play with a lenient supervisor"

  def run(_) do
    SupervisedBand.start(:normal, :lenient)
    :timer.sleep :infinity
  end
end
