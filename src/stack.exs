Code.require_file("src/utils.exs")
Code.require_file("src/opcodes.exs")

defmodule Stack do
  use Bitwise
  use Utils
  use Opcodes

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
