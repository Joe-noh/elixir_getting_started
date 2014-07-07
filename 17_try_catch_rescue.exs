defmodule MyError, do: defexception message: "oops"

ExUnit.start

defmodule TryCatchRescue do
  use ExUnit.Case

  test "Errors" do
    assert_raise MyError, "oops", fn ->
      raise MyError
    end

    assert_raise MyError, "custom message", fn ->
      raise MyError, message: "custom message"
    end

    result = try do
      raise "oops"
    rescue
      _e in [RuntimeError, ArgumentError] -> "wow"
      MyError -> "my error"
    end
    assert result == "wow"
  end

  test "Throws" do
    result = try do
      Enum.each -50..50, fn(x) ->
        if rem(x, 13) == 0, do: throw(x)
      end
      "Got nothing"
    catch
      x -> "Got #{x}"
    end
    assert result == "Got -39"
  end

  test "Exit" do
    result = try do
      exit "I am exiting"
    catch
      :exit, _x -> "not really"
    end
    assert result == "not really"
  end

  test "After" do
    {:ok, file} = File.open("/tmp/hello.txt")
    assert Process.alive?(file) == true

    try do
      raise "oops"
    rescue
      e -> e.message
    after
      File.close file
    end
    assert Process.alive?(file) == false
  end
end
