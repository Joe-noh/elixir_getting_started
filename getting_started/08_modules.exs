defmodule MyModule do
  def sum(a, b) do
    private_sum a, b
  end

  defp private_sum(a, b) do
    a + b
  end

  def zero?(0) do
    true
  end

  def zero?(x) when is_number(x) do
    false
  end

  def join(a, b, sep \\ " ") do
    a <> sep <> b
  end

  def do_it(x \\ inspect([1, 2, 3])) do
    x
  end
end

ExUnit.start

defmodule Modules do
  use ExUnit.Case

  test "Named Functions" do
    assert MyModule.sum(1, 2) == 3
    assert_raise UndefinedFunctionError, fn ->
      MyModule.private_sum(1, 2)
    end

    assert MyModule.zero?(0) == true
    assert MyModule.zero?(3) == false
    assert_raise FunctionClauseError, fn ->
      MyModule.zero? [1, 2, 3]
    end
  end

  test "Function Capturing" do
    sum = &MyModule.sum/2
    assert is_function(sum) == true
    assert sum.(1, 2) == 3
  end

  test "Default Arguments" do
    assert MyModule.join("hello", "world")      == "hello world"
    assert MyModule.join("hello", "world", "_") == "hello_world"

    assert MyModule.do_it == "[1, 2, 3]"
  end
end
