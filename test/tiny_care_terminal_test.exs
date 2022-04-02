defmodule TinyCareTerminalTest do
  use ExUnit.Case
  doctest TinyCareTerminal

  test "greets the world" do
    assert TinyCareTerminal.hello() == :world
  end
end
