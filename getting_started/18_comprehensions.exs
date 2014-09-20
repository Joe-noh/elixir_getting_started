ExUnit.start

defmodule Conprehensions do
  use ExUnit.Case

  test "Generators and Filters" do
    assert (for n <- 1..4, do: n * n) == [1, 4, 9, 16]

    values = [good: 1, good: 2, bad: 3, good: 4]
    assert (for {:good, n} <- values, do: n * n) == [1, 4, 16]

    require Integer
    assert (for n <- 1..4, Integer.is_odd(n), do: n * n) == [1, 9]

    assert (for i <- 1..2, j <- 3..4, do: i * j) == [3, 4, 6, 8]
  end

  test "Bitstring Generators" do
    pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
    triples = for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}

    assert triples == [{213, 45, 132}, {64, 76, 32}, {76, 0, 0}, {234, 32, 15}]
  end

  test "Into" do
    str = (for <<c <- " h e  ll o">>, c != ?\s, into: "", do: <<c>>)
    assert str == "hello"
  end
end
