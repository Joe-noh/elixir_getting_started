defmodule KittyServerTest do
  use ExUnit.Case

  test "order cat" do
    pid = KittyServer.open_shop

    cat = KittyServer.order_cat(pid, "tama", "brown", "ugly")
    assert cat == %Cat{name: "tama", color: "brown", description: "ugly"}
  end

  test "return cat" do
    pid = KittyServer.open_shop

    cat = KittyServer.order_cat(pid, "tama", "brown", "ugly")
    KittyServer.return_cat(pid, cat)

    assert cat == KittyServer.order_cat(pid, "mike", "white", "pretty")
  end

  test "returning cat works like a stack" do
    pid = KittyServer.open_shop

    tama  = KittyServer.order_cat(pid, "tama", "brown", "ugly")
    buchi = KittyServer.order_cat(pid, "buchi", "black", "cute")
    KittyServer.return_cat(pid, tama)
    KittyServer.return_cat(pid, buchi)

    assert buchi == KittyServer.order_cat(pid, "mike", "white", "pretty")
    assert tama  == KittyServer.order_cat(pid, "mike", "white", "pretty")
  end

  test "close shop" do
    pid = KittyServer.open_shop

    assert :ok == KittyServer.close_shop(pid)
    :timer.sleep 100  # wait for termination

    assert Process.alive?(pid) == false
    catch_exit KittyServer.order_cat(pid, "mike", "white", "pretty")
  end
end
