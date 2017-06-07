defmodule Exthereum.RLPTest do
  use ExUnit.Case

  alias Exthereum.RLP

  test 'encodes a single byte and that single byte is < 128' do
    item = "a"
    result = item |> RLP.encode

    ^item = result
  end

  test 'encodes a single byte and that single byte is >= 128' do
    item = "ю"
    result = item |> RLP.encode

    <<194, 130, 209, 142>> = result
  end
end
