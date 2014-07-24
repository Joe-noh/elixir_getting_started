defmodule Stack do
  def start_link(args) do
    Agent.start_link(fn -> args end)
  end

  def push(pid, item) do
    Agent.update(pid, fn list -> [item|list] end)
  end

  def pop(pid) do
    Agent.get_and_update pid, fn list ->
      case list do
        []    -> {nil, []}
        [h|t] -> {h, t}
      end
    end
  end
end
