Code.require_file("lib/evm/opcodes.exs")

defmodule EVM.Storage do
  use EVM.Utils
  use EVM.Opcodes

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
      _->
        storage
    end
  end
end
