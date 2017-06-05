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
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          stack_push(stack, wrap(left + right))
        :addmod ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          {mod, stack} = stack_pop(stack)
          stack_push(stack, rem((left + right), mod))
        _->
          stack
      end
    end
  end
end
