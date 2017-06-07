defmodule Exthereum.RLP do
  def encode(<< code_point :: utf8 >> = item)
      when byte_size(item) == 1
      when code_point < 128 do
    item
  end

  def encode(item) when byte_size(item) < 56 do
    prefix_codepoint = 128 + byte_size(item)
    prefix = << prefix_codepoint :: utf8 >> |> IO.inspect

    prefix <> item
  end
end
