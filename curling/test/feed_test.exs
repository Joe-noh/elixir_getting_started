defmodule FeedTest do
  use ExUnit.Case

  alias Curling.Feed

  test "init" do
    assert Feed.init([self]) == {:ok, self}
  end

  test "handle event" do
    result = Feed.handle_event(:an_event, self)

    assert result == {:ok, self}
    assert_receive {Curling.Feed, :an_event}
  end
end
