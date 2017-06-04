Code.require_file("lib/evm/stack.exs")
Code.require_file("lib/evm/log.exs")
Code.require_file("lib/evm/storage.exs")
Code.require_file("lib/evm/opcodes.exs")
Code.require_file("lib/evm/utils.exs")

defmodule EVM do
  alias EVM.Stack
  alias EVM.Log
  alias EVM.Storage
  use EVM.Opcodes
  use EVM.Utils

  def run(state, code) do
    step(state, code, [], 0)
  end

  def step(state, code, stack, program_counter) do
    opcode = :binary.at(code, program_counter)

    stack = Stack.step(stack, code, program_counter, opcode)
    state = update_in(
      state,
      [:accounts, state["address"], "storage"],
      &Storage.step(&1, stack, opcode)
    )
    Log.step(code, program_counter, opcode)

    if program_counter + 1 < byte_size(code) do
      step(
        state,
        code,
        stack,
        next_instruction(program_counter, opcode)
      )
    else
      state
    end
  end

  def next_instruction(program_counter, opcode) do
    if is_push_opcode(opcode) do
      program_counter + size_of_push(opcode) + 1
    else
      program_counter + 1
    end
  end
end
