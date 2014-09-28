defmodule PpoolTest do
  use ExUnit.Case

  setup do
    Ppool.start_link

    on_exit fn ->
      Ppool.stop
    end
  end

  test "it warns me in specific interval" do
    Ppool.start_pool :nagger, 2, {Ppool.Nagger, :start_link, []}

    {:ok, pid1} = Ppool.run :nagger, ["finish the chapter", 100, 10, self]
    {:ok, pid2} = Ppool.run :nagger, ["watch a good movie", 400, 10, self]

    assert_receive {pid1, "finish the chapter"}, 110
    assert_receive {pid1, "finish the chapter"}, 110
    assert_receive {pid1, "finish the chapter"}, 110
    assert_receive {pid2, "watch a good movie"}, 110

    Ppool.stop_pool :nagger
  end

  test "warns me specific times" do
    Ppool.start_pool :nagger, 2, {Ppool.Nagger, :start_link, []}

    {:ok, pid} = Ppool.run :nagger, ["finish the chapter", 100, 3, self]
    :timer.sleep 500

    assert_received {pid, "finish the chapter"}
    assert_received {pid, "finish the chapter"}
    assert_received {pid, "finish the chapter"}

    refute_received {pid, "finish the chapter"}

    Ppool.stop_pool :nagger
  end

  test "return :noalloc if it was full" do
    Ppool.start_pool :nagger, 2, {Ppool.Nagger, :start_link, []}

    {:ok, pid1} = Ppool.run :nagger, ["finish the chapter", 1000, 10, self]
    {:ok, pid2} = Ppool.run :nagger, ["watch a good movie", 4000, 10, self]

    assert :noalloc == Ppool.run :nagger, ["clean up a bit", 4000, 10, self]
    Ppool.stop_pool :nagger
  end

  test "async queue" do
    Ppool.start_pool :nagger, 1, {Ppool.Nagger, :start_link, []}

    Ppool.async_queue :nagger, ["pay the bills", 400, 2, self]
    Ppool.async_queue :nagger, ["plant a tree",  450, 2, self]

    assert_receive {_, "pay the bills"}, 500
    refute_receive {_, "plant a tree"}
    assert_receive {_, "pay the bills"}, 500

    assert_receive {_, "plant a tree"}, 500
    Ppool.stop_pool :nagger
  end

  test "sync queue" do
    Ppool.start_pool :nagger, 1, {Ppool.Nagger, :start_link, []}

    Ppool.sync_queue :nagger, ["pet a dog",      400, 2, self]
    Ppool.sync_queue :nagger, ["chase tornado", 1000, 2, self]  # block!

    assert_received {_, "pet a dog"}
    assert_received {_, "pet a dog"}

    Ppool.stop_pool :nagger
  end
end
