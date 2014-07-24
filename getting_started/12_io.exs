ExUnit.start

defmodule IOTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "IO Module" do
    output = capture_io fn ->
      IO.puts "hello"
    end
    assert output == "hello\n"

    output = capture_io :stderr, fn ->
      IO.puts :stderr, "hello"
    end
    assert output == "hello\n"
  end

  test "File Module" do
    path = "/tmp/hello.txt"

    {:ok, file} = File.open path, [:write, :utf8]
    IO.write file, "hello"
    File.close file

    assert File.read(path)  == {:ok, "hello"}
    assert File.read!(path) == "hello"
    assert File.read("unknown") == {:error, :enoent}
    assert_raise File.Error, fn ->
      File.read!("unknown")
    end
  end

  test "Path Module" do
    assert Path.join("usr", "bin") == "usr/bin"
    assert Path.expand("~/Documents") == System.get_env("HOME") <> "/Documents"
  end

  test "Processes and Group Leaders" do
    assert is_pid(Process.group_leader) == true

    output = capture_io fn ->
      IO.puts Process.group_leader, "hello"
    end
    assert output == "hello\n"
  end

  test "iodata and chardata" do
    output = capture_io fn ->
      IO.puts 'hello world'
    end
    assert output == "hello world\n"

    output = capture_io fn ->
      IO.puts ['hello', ?\s, "world"]
    end
    assert output == "hello world\n"
  end
end
