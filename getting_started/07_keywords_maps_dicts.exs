ExUnit.start

defmodule KeywordsMapsDicts do
  use ExUnit.Case

  test "Keyword Lists" do
    list = [{:a, 1}, {:b, 2}]

    assert list == [a: 1, b: 2]
    assert list[:a] == 1
    assert (list ++ [c: 3]) == [a: 1, b: 2, c: 3]
    assert ([c: 3] ++ list) == [c: 3, a: 1, b: 2]
    assert [a: 0, a: 1][:a] == 0

    [k: v] = [k: 1]
    assert v == 1
    assert_raise MatchError, fn ->
      [a: _v, b: _v] = [a: 1]
    end
  end

  test "Maps" do
    map = %{:a => 1, :b => 2}

    assert map == %{a: 1, b: 2}
    assert map[:a] == 1
    assert map.a   == 1
    assert %{a: 1, a: 2} == %{a: 2}

    %{a: a} = map
    assert a == 1
    assert (%{} = map) == map
    assert_raise MatchError, fn ->
      %{c: _c} = map
    end
    assert %{map | a: 3} == %{a: 3, b: 2}
    assert_raise ArgumentError, fn ->
      %{map | c: 3}
    end
  end

  test "Dicts" do
    # A dictionary is like an interface
    # Both keyword lists and maps implement this
    kw  = []
    map = %{}

    assert Dict.put(kw,  :a, 1) == [a: 1]
    assert Dict.put(map, :a, 1) == %{a: 1}
  end
end
