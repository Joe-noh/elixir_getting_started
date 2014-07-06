ExUnit.start

defmodule EnumeralesAndStreams do
  use ExUnit.Case

  test "Enumerables" do
    assert Enum.reduce([1, 2, 3], 0, fn(x, acc) -> x + acc end) == 6
    assert Enum.reduce([1, 2, 3], 0, &(&1 + &2)) == 6
    assert Enum.reduce([1, 2, 3], 0, &+/2) == 6
  end

  test "Eager vs Lazy" do
    odd? = &(rem(&1, 2) != 0)

    # Enum is eager
    assert (1..100 |> Enum.map(&(&1 * 3))   |> Enum.filter(odd?)   |> Enum.sum) == 7500
    # Stream is lazy
    assert (1..100 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum) == 7500
    # Results are same
  end

  test "Streams" do
    stream = Stream.cycle([1, 2, 3])
    assert Enum.take(stream, 10) == [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]

    # String.next_codepoint("hey") #=> {"h", "ey"}
    stream = Stream.unfold("hello", &String.next_codepoint/1)
    assert Enum.take(stream, 3) == ["h", "e", "l"]

    stream = File.stream!("10_enumerables_streams.exs")
    assert Enum.take(stream, 2) == ["ExUnit.start\n", "\n"]
  end
end
