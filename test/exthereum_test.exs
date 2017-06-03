defmodule ExthereumTest do
  use ExUnit.Case, async: true

  test "EVM Tests" do
    {:ok, body} = File.read("test/tests/VMTests/vmArithmeticTest.json")
    tests = Poison.decode!(body)
    {_, state} = EVM.run(tests["add0"]["env"], tests["add0"]["pre"], tests["add0"]["exec"])
    assert state == tests["add0"]["post"]
  end
end
