defmodule MySigils do
  def sigil_i(string, []), do: String.to_integer(string)
end

ExUnit.start

defmodule Sigils do
  use ExUnit.Case

  test "Regular Expressions" do
    assert ("foo" =~ ~r/foo|bar/) == true
    assert ("baz" =~ ~r/foo|bar/) == false
  end

  test "Strings Char Lists and Words Sigils" do
    assert ~s(this is "quoted") == "this is \"quoted\""
    assert ~c(this is "quoted") == 'this is "quoted"'

    assert ~w(a b c)s == ["a", "b", "c"]
    assert ~w(a b c)c == ['a', 'b', 'c']
    assert ~w(a b c)a == [:a,  :b,  :c ]

    assert ~s(Me \x26 #{:You}) == "Me & You"
    assert ~S(Me & #{:You})    == "Me & \#{:You}"
  end

  test "Custom Sigils" do
    import MySigils

    assert ~i(0013) == 13
  end
end
