ExUnit.start

defmodule BasicTypes do
  use ExUnit.Case

  test "Basic Types" do
    assert is_integer(1)              == true
    assert is_integer(0x1F)           == true
    assert is_integer(011)            == true
    assert is_integer(0b101)          == true
    assert is_float(1.5)              == true
    assert is_float(1.5e-10)          == true
    assert is_number(1)               == true
    assert is_number(1.5)             == true
    assert is_atom(:atom)             == true
    assert is_atom(true)              == true
    assert is_boolean(false)          == true
    assert is_bitstring("elixir")     == true
    assert is_bitstring("エリクサー") == true
    assert is_binary(<<1, 2, 3>>)     == true
    assert is_binary("elixir")        == true
    assert is_list('elixir')          == true
    assert is_list([1, 2, 3])         == true
    assert is_tuple({1, 2, 3})        == true
    assert is_function(fn x -> x end) == true
    assert is_function(&IO.puts/1)    == true
    assert is_map(%{one: 1})          == true
    assert is_pid(self)               == true
    assert is_port(hd Port.list)      == true
    assert is_reference(make_ref)     == true
  end

  test "Basic Arithmetic" do
    assert 1 + 2 == 3
    assert 5 * 5 == 25
    assert 10 / 2 == 5.0
    assert div(10, 2) == 5
    assert rem(10, 3) == 1
  end

  test "Strings" do
    str = "world"
    assert "hello #{str}" == "hello world"
    assert String.length(str) == 5
    assert String.upcase(str) == "WORLD"
  end

  test "Anonymous Functions" do
    add = fn (a, b) -> a + b end
    assert is_function(add)    == true
    assert is_function(add, 2) == true  # arity
    assert is_function(add, 1) == false
  end

  test "Lists" do
    assert [1, 2, 1, 3] ++ [1, 3] == [1, 2, 1, 3, 1, 3]
    assert [1, 2, 1, 3] -- [1, 3] == [2, 1]
    assert hd([1, 2, 3]) == 1
    assert tl([1, 2, 3]) == [2, 3]

    [first, second | rest] = [1, 2, 3]
    assert first  == 1
    assert second == 2
    assert rest   == [3]
  end

  test "Tuples" do
    tuple = {:ok, "hello"}
    assert elem(tuple, 0) == :ok
    assert elem(tuple, 1) == "hello"
    assert put_elem(tuple, 1, "world") == {:ok, "world"}
    assert tuple == {:ok, "hello"}
  end
end



