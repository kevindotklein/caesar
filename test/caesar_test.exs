defmodule CaesarTest do
  use ExUnit.Case
  doctest Caesar

  test "greets the world" do
    assert Caesar.hello() == :world
  end
end
