Code.require_file("src/opcodes.exs")

defmodule Storage do
  use Utils
  use Opcodes

  def step(accounts, stack, opcode) do
    case @opcodes[opcode] do
      :sstore ->
        [register | [value | _]] = stack
        %{encode(register) => encode(value)}
      _->
        accounts
    end
  end
end
