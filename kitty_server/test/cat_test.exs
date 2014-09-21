defmodule CatTest do
  use ExUnit.Case

  test "default values" do
    cat = %Cat{}

    assert cat.name  == ""
    assert cat.color == ""
    assert cat.description == ""
  end

  test "new" do
    cat = Cat.new("tama", "brown", "ugly")

    assert cat.name  == "tama"
    assert cat.color == "brown"
    assert cat.description == "ugly"
  end
end
