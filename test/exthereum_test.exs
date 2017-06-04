Code.require_file("test/utils.exs")
defmodule ExthereumTest do
  use ExUnit.Case, async: true
  use Test.Utils

  @passing_tests [
    "add0"
  ]

  test "vmArithmeticTests" do
    {:ok, body} = File.read("test/tests/VMTests/vmArithmeticTest.json")
    tests = Poison.decode!(body)
    for test <- @passing_tests do
      state = tests[test]["env"]
        |> Map.merge(tests[test]["exec"])
        |> Map.merge(%{accounts: tests[test]["pre"]})


      code = hex_to_binary(tests[test]["exec"]["code"])


      state = EVM.run(state, code)
      assert state[:gas] == hex_to_int(tests[test]["exec"]["gas"]) - hex_to_int(tests[test]["gas"])
      assert state[:accounts] == tests[test]["post"]
    end
  end
end
