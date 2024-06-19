defmodule KobboTest do
  use ExUnit.Case
  doctest Kobbo

  test "greets the world" do
    assert Kobbo.hello() == :world
  end
end
