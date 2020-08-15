defmodule OauthDemoTest do
  use ExUnit.Case
  doctest OauthDemo

  test "greets the world" do
    assert OauthDemo.hello() == :world
  end
end
