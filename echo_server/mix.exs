defmodule EchoServer.Mixfile do
  use Mix.Project

  def project do
    [app: :echo_server,
     version: "0.0.1",
     elixir: ">= 1.0.0",
     deps: deps]
  end

  def application do
    [applications: [:logger],
     mod: {EchoServer, []}]
  end

  defp deps do
    []
  end
end
