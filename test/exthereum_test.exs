defmodule ExthereumTest do
  use ExUnit.Case, async: true

  test "EVM Tests" do
    {:ok, body} = File.read("test/tests/VMTests/vmArithmeticTest.json")
    tests = Poison.decode!(body)
    state = tests["add0"]["env"]
      |> Map.merge(tests["add0"]["exec"])
      |> Map.merge(%{accounts: tests["add0"]["pre"]})


    code = tests["add0"]["exec"]["code"]
      |> String.slice(2..-1)
      |> Base.decode16!(case: :mixed)


    state = EVM.run(state, code)
    assert state[:accounts] == tests["add0"]["post"]
  end
end
