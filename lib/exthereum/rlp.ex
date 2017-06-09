defmodule Exthereum.RLP do
  def encode(item)
      when is_binary(item) and byte_size(item) == 1 do
    item
  end

  def encode(item)
      when is_binary(item) and byte_size(item) < 56 do
    prefix = 128 + byte_size(item)

    << prefix >> <> item
  end
end
