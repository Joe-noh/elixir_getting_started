ExUnit.start

defmodule Processes do
  use ExUnit.Case

  test"Spawn" do
    pid = spawn fn -> :timer.sleep 500 end
    assert Process.alive?(pid)  == true

    :timer.sleep 1000
    assert Process.alive?(pid)  == false

    assert Process.alive?(self) == true
  end

  test "Send and Receive" do
    send self, {:hello, "world"}
    message = receive do
      {:hello, msg} -> msg
      {:world, _} -> "won't match"
    end
    assert message == "world"

    result = receive do
      {:hello, msg} -> msg
    after
      1000 -> "received nothing"
    end
    assert result == "received nothing"

    parent = self
    spawn fn -> send(parent, {:hello, self}) end
    assert_receive {:hello, _}
  end

  test "Links" do
    assert is_pid(spawn fn -> raise "oops" end) == true
  end

  defmodule KV do
    def start do
      {:ok, spawn_link fn -> loop(%{}) end}
    end

    defp loop(map) do
      receive do
        {:get, key, caller} ->
          send caller, Map.get(map, key)
          loop map
        {:set, key, value} ->
          loop Map.put(map, key, value)
      end
    end
  end

  test "KV" do
    {:ok, kv} = KV.start
    Process.register kv, :kv

    send kv, {:set, :a, 1}
    send :kv, {:get, :a, self}
    result = receive do
      val -> val
    end
    assert result == 1

    Process.exit(kv, :normal)
  end
end

