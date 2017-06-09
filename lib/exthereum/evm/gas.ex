defmodule Exthereum.EVM.Gas do
  use Exthereum.EVM.Opcodes

  @static_gas_prices %{
    add: 3,
    sub: 3,
    smod: 5,
    mod: 5,
    addmod: 8,
    eq: 3,
    push1: 3,
    push32: 3,
  }
  @dynamic_gas_prices %{
    sstore_empty: 5_000,
    sstore_replace: 5_000,
    sstore_new: 20_000,
  }

  def price(stack, storage, opcode) do
    cond do
      opcode == atom_to_opcode(:sstore) ->
        sstore_price(stack, storage)
      @static_gas_prices[@opcodes[opcode]] ->
        @static_gas_prices[@opcodes[opcode]]
      true ->
        0
    end
  end

  def sstore_price(stack, storage) do
    {:ok, address} = Enum.fetch(stack, 0)
    {:ok, value} = Enum.fetch(stack, 1)

    cond do
      value == 0 ->
        @dynamic_gas_prices[:sstore_empty]
      storage[address] ->
        @dynamic_gas_prices[:sstore_replace]
      true ->
        @dynamic_gas_prices[:sstore_new]
    end
  end
end
