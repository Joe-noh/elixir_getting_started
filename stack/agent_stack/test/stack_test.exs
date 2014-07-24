defmodule StackTest do
  use ExUnit.Case

  test :basic do
    {:ok, pid} = Stack.start_link []

    assert Stack.pop(pid) == nil

    Stack.push pid, 1
    Stack.push pid, 2
    Stack.push pid, 3

    assert Stack.pop(pid) == 3
    assert Stack.pop(pid) == 2
    assert Stack.pop(pid) == 1
    assert Stack.pop(pid) == nil
  end

  test :with_initial_list do
    {:ok, pid} = Stack.start_link [1, 2]

    assert Stack.pop(pid) == 1
    assert Stack.pop(pid) == 2
  end
end
