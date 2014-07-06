defmodule MyModule do
  def sum(x) when is_list(x), do: sum_list(x, 0)

  defp sum_list([head | list], acc) do
    sum_list(list, acc + head)
  end

  defp sum_list([], acc), do: acc
end

ExUnit.start

defmodule Recursion do
  use ExUnit.Case

  test "Recursion" do
    assert MyModule.sum([1, 2, 3]) == 6
  end

  test "Mapping" do
    assert Enum.reduce([1, 2, 3], 0, fn(x, acc) -> x + acc end) == 6
    assert Enum.reduce([1, 2, 3], 0, &(&1 + &2)) == 6
    assert Enum.reduce([1, 2, 3], 0, &+/2) == 6
  end
end
