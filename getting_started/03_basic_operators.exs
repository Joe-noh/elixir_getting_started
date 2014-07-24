ExUnit.start

defmodule BasicOperators do
  use ExUnit.Case

  test "Basic Operators" do
    assert "foo" <> "bar"       == "foobar"
    assert (true and not false) == true
    assert (true or false)      == true
    assert (true or raise(""))  == true
    assert (false || 11)        == 11
    assert (10 || 11)           == 10
    assert (nil && 13)          == nil
    assert (true && 17)         == 17
    assert (!nil)               == true
    assert (1 == 1.0)           == true
    assert (1 === 1.0)          == false
    assert (:atom < %{})        == true
  end
end

