defmodule Exthereum.EVM.Storage do
  use Exthereum.EVM.Utils
  use Exthereum.EVM.Opcodes

  def step(storage, stack, opcode) do
    case @opcodes[opcode] do
      :sstore ->
        [register | [value | _]] = stack
        if value == 0 do
          storage
        else
          storage
            |> Map.merge(%{encode(register) => encode(value)})
        end
      _ ->
        storage
    end
  end
end
