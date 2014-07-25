defmodule TaskParallel do
  def do_sequential do
    Enum.map functions, fn (func) ->
      func.()
    end
  end

  def do_parallel do
    Enum.map(functions, fn (func) ->
      Task.async(func)
    end)
    |> Enum.map(&Task.await/1)
  end

  defp functions do
    [
      fn -> :timer.sleep 1000 end,
      fn -> :timer.sleep 1000 end,
      fn -> :timer.sleep 1000 end,
      fn -> :timer.sleep 1000 end
    ]
  end
end
