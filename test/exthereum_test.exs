defmodule ExthereumTest do
  use ExUnit.Case, async: true
  use Test.Utils

  @passing_tests [
    "add0",
    "add1",
    "add2",
    "add3",
    "add4",
    "addmod0",
    "addmod1",
    "addmod1_overflow2",
    "addmod1_overflow3",
    "addmod1_overflow4",
    "addmod1_overflowDiff",
    "addmod2",
    "addmod2_0",
    "addmod2_1",
    "addmod3",
    "addmod3_0",
    "addmodBigIntCast",
    "addmodDivByZero",
    "addmodDivByZero1",
    "addmodDivByZero2",
    "addmodDivByZero3",
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

      assert state[:accounts] == tests[test]["post"]
      assert state[:gas] == hex_to_int(tests[test]["gas"])
    end
  end
end
