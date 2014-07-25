defmodule TaskParallelTest do
  use ExUnit.Case

  test "do_sequential takes long time" do
    {_, start_sec, _} = :os.timestamp
    TaskParallel.do_sequential
    {_, end_sec, _} = :os.timestamp
    assert (end_sec - start_sec) > 2  # fail rarely
  end

  test "do_parallel ends quickly" do
    {_, start_sec, _} = :os.timestamp
    TaskParallel.do_parallel
    {_, end_sec, _} = :os.timestamp
    assert (end_sec - start_sec) < 2  # fail rarely
  end
end
