# credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

defmodule Exthereum.EVM.Stack do
  use Exthereum.EVM.Utils
  use Exthereum.EVM.Opcodes

  def step(stack, code, program_counter, opcode) do
    if is_push_opcode(opcode) do
      [value_at(code, program_counter, opcode) | stack]
    else
      case @opcodes[opcode] do
        :add ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          stack_push(stack, wrap(left + right))
        :sub ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          stack_push(stack, wrap(left - right))
        :smod ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          left = to_signed(left)
          right = to_signed(right)
          stack_push(stack, to_unsigned(mod(left, right)))
        :mod ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          stack_push(stack, mod(left, right))
        :addmod ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          {mod_by, stack} = stack_pop(stack)
          stack_push(stack, mod((left + right), mod_by))
        :eq ->
          {left, stack} = stack_pop(stack)
          {right, stack} = stack_pop(stack)
          stack_push(stack, (if right == left, do: 1, else: 0))
        _ ->
          stack
      end
    end
  end
end
