ExUnit.start

defmodule PatternMatching do
  use ExUnit.Case

  test "Match Operator" do
    x = 1
    assert (1 = x) == 1
    assert_raise MatchError, fn -> x = 1; 2 = x end
  end

  test "Pattern Matching" do
    {a, b, c} = {:hello, "world", 42}
    assert a == :hello
    assert b == "world"
    assert c == 42
    assert_raise MatchError, fn -> {_a, _b, _c} = {:hello, "world"} end
    assert_raise MatchError, fn -> {_a, _b, _c} = [:hello, "world", 42] end
    {:ok, code} = {:ok, 200}
    assert code == 200
    assert_raise MatchError, fn -> {:ok, _code} = {:error, :enoent} end
  end

  test "Pin Operator" do
    x = 10
    x = 20  # Variables can be re-bounded
    assert_raise MatchError, fn ->
      x  = 1
      ^x = 2  # will raise
    end
  end
end

