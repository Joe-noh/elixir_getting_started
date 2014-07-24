defmodule User do
  defstruct name: "jose", age: 27
end

ExUnit.start

defmodule Structs do
  use ExUnit.Case

  test "Structs" do
    jose = %User{}
    assert jose.name == "jose"
    assert jose.age  == 27

    eric = %User{name: "eric"}
    assert eric.name == "eric"
    assert eric.age  == 27

    assert is_map(eric) == true

    eric = %{eric | age: 28}
    assert eric.age == 28

    assert_raise ArgumentError, fn ->
      %{eric | oops: "field"}
    end

    %User{name: name} = jose
    assert name == "jose"

    assert_raise MatchError, fn ->
      %User{} = %{}
    end

    assert jose.__struct__ == User

    assert_raise Protocol.UndefinedError, fn ->
      eric[:name]
    end
    assert_raise UndefinedFunctionError, fn ->
      Dict.get(eric, :name)
    end
  end
end
