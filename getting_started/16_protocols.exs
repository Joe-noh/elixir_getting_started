defprotocol Blank do
  def blank?(x)
end

defimpl Blank, for: Integer do
  def blank?(_), do: false
end

defimpl Blank, for: List do
  def blank?([]), do: true
  def blank?(_),  do: false
end

defimpl Blank, for: Map do
  def blank?(map), do: map_size(map) == 0
end

defimpl Blank, for: Atom do
  def blank?(false), do: true
  def blank?(nil),   do: true
  def blank?(_),     do: false
end

ExUnit.start

defmodule ProtocolTest do
  use ExUnit.Case

  test "Protocols" do
    assert Blank.blank?(0)   == false
    assert Blank.blank?([])  == true
    assert Blank.blank?(%{}) == true

    assert_raise Protocol.UndefinedError, fn ->
      Blank.blank? "hello"
    end
  end
end
