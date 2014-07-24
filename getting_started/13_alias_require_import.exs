defmodule MyModule do
  def say do
    "hello"
  end
end

ExUnit.start

defmodule AliasRequireImport do
  use ExUnit.Case

  test "Alias" do
    alias MyModule, as: MM
    assert MM.say == MyModule.say
  end

  test "Require" do
    require Integer  # CompileError will be thrown without this
    assert Integer.odd?(3) == true
  end

  test "Import" do
    import List, only: [duplicate: 2]
    assert duplicate(:ok, 3) == [:ok, :ok, :ok]
  end

  test "Aliases" do
    assert to_string(String) == "Elixir.String"
    assert :"Elixir.String" == String
  end
end
