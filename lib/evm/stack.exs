Code.require_file("lib/evm/utils.exs")
Code.require_file("lib/evm/opcodes.exs")

defmodule EVM.Stack do
  use EVM.Utils
  use EVM.Opcodes

  def step(stack, code, program_counter, opcode) do
    if is_push_opcode(opcode) do
      [value_at(code, program_counter, opcode) | stack]
    else
      case @opcodes[opcode] do
        :add ->
          [left | [right | stack]] = stack
          [wrap(left + right) | stack]
        _->
          stack
      end
    end
  end
end
