defmodule KittyServer do
  use GenServer

  def open_shop do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    pid
  end

  def order_cat(pid, name, color, desc) do
    GenServer.call(pid, {:order, name, color, desc})
  end

  def return_cat(pid, cat) do
    GenServer.cast(pid, {:return, cat})
  end

  def close_shop(pid) do
    GenServer.cast(pid, :close)
  end

  def handle_call({:order, name, color, desc}, _from, []) do
    cat = Cat.new(name, color, desc)
    {:reply, cat, []}
  end

  def handle_call({:order, _, _, _}, _from, [cat | rest]) do
    {:reply, cat, rest}
  end

  def handle_cast({:return, cat}, cats) do
    {:noreply, [cat | cats]}
  end

  def handle_cast(:close, cats) do
    {:stop, :normal, cats}
  end
end

defmodule Cat do
  defstruct name: "", color: "", description: ""

  def new(name, color, desc) do
    %Cat{name: name, color: color, description: desc}
  end
end
