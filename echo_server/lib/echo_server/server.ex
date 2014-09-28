defmodule EchoServer.Server do
  alias :gen_tcp, as: GenTCP

  def start_link(port) do
    {:ok, socket} = GenTCP.listen port, [:binary, packet: :line, active: false]
    loop socket
  end

  defp loop(socket) do
    {:ok, client} = GenTCP.accept(socket)
    echo_back client
    loop socket
  end

  defp echo_back(client) do
    {:ok, data} = GenTCP.recv(client, 0)
    GenTCP.send(client, (data |> to_string |> String.capitalize))
    echo_back(client)
  end
end
