Code.require_file("lib/evm/utils.exs")
Code.require_file("lib/evm/gas_prices.exs")

defmodule EVM.Gas do
  use EVM.Utils
  use EVM.Opcodes
  @gas_prices %{
    add: 3,
    push1: 3,
    push32: 3,
    sstore: 20000,
  }

  def price(stack, storage, opcode) do
    cond do
      opcode == atom_to_opcode(:sstore) ->
        sstore_price(stack, storage)
      @gas_prices[@opcodes[opcode]] ->
        @gas_prices[@opcodes[opcode]]
      true ->
        0
    end
  end

  def sstore_price(stack, storage) do
    [address | _] = stack

    if storage[address] do
      5000
    else
      20000
    end
  end
end
