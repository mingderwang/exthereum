defmodule Exthereum.RLPTest do
  use ExUnit.Case
  alias Exthereum.RLP

  setup_all do
    {:ok, body} = File.read("test/tests/RLPTests/rlptest.json")
    test_data = Poison.decode!(body)
    passing_tests = [
      "emptystring",
      "bytestring00",
      "bytestring01",
      "shortstring",
      "shortstring2"
    ]

    {
      :ok,
      [
        test_data: test_data,
        passing_tests: passing_tests
      ]
    }
  end

  test "rpltest",
      %{test_data: test_data, passing_tests: passing_tests} do
    for test <- passing_tests do
      input = test_data[test]["in"]
      output = test_data[test]["out"]

      result =
        input
        |> RLP.encode
        |> Base.encode16(case: :lower)

      assert result == output
    end
  end
end
