defmodule PpoolTest do
  use ExUnit.Case

  test "boot" do
    Ppool.start_link
    Ppool.start_pool Ppool.Nagger, 2, {Ppool.Nagger, :start_link, []}

    :timer.sleep 3000
  end
end
