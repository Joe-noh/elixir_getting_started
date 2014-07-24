ExUnit.start

defmodule CaseCondIf do
  use ExUnit.Case

  test "Case" do
    result = case {1, 2, 3} do
      {4, 5, 6} ->
        false
      {1, _x, 3} ->
        true
      _ ->
        false
    end
    assert result == true

    x = 1
    result = case 10 do
      ^x ->
        false
      _ ->
        true
    end
    assert result == true

    result = case {1, 2, 3} do
      {1, x, 3} when x > 0 ->
        true
      _ ->
        false
    end
    assert result = true

    assert_raise CaseClauseError, fn ->
      case :ok do
        :error -> "Error"
      end
    end
  end

  test "Cond" do
    result = cond do
      2 + 2 == 5 ->
        false
      2 * 2 == 3 ->
        false
      1 + 1 == 2 ->
        true
    end
    assert result == true

    assert_raise CondClauseError, fn ->
      cond do
        false -> ""
      end
    end

    result = cond do
      :any_value_besides_nil_and_false -> true
    end
    assert result == true
  end

  test "If and Unless" do
    if 1 == 1 do
      x = true
    else
      x = false
    end
    assert x == true

    result = unless 1 == 2 do
      true
    end
    assert result == true
  end

  test "Do Block" do
    assert (if true, do: 1, else: 0) == 1

    assert (if true do
      1
    else
      0
    end) == 1
  end
end

