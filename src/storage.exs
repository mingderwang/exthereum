defmodule Storage do
  use Bitwise

  def step(accounts, stack, opcode, address) do
    case opcode do
      0x55 ->
        [register | [value | _]] = stack
        storage = %{encode(register) => encode(value)}
        put_in(accounts, [address, "storage"], storage)
      _->
        accounts
    end
  end

  def encode(value) do
    "0x" <> (value |> :binary.encode_unsigned |> Base.encode16 |> String.downcase)
  end

end
