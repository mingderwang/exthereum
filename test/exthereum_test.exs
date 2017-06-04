Code.require_file("test/utils.exs")
defmodule ExthereumTest do
  use ExUnit.Case, async: true
  use Test.Utils

  @passing_tests [
    "add0",
    "add1",
    "add2",
    "add3",
    "add4",
  ]

  test "vmArithmeticTests" do
    {:ok, body} = File.read("test/tests/VMTests/vmArithmeticTest.json")
    tests = Poison.decode!(body)
    for test <- @passing_tests do
      IO.puts "-----" <> test <> "-----"
      state = %{
          gas: hex_to_int(tests[test]["exec"]["gas"]),
          from: tests[test]["exec"]["address"],
          accounts: tests[test]["pre"]
        }
      code = hex_to_binary(tests[test]["exec"]["code"])


      state = EVM.run(state, code)

      assert state[:gas] == hex_to_int(tests[test]["gas"])
      assert state[:accounts] == tests[test]["post"]
    end
  end
end
