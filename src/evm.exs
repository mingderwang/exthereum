Code.require_file("src/stack.exs")
Code.require_file("src/log.exs")
Code.require_file("src/storage.exs")
Code.require_file("src/opcodes.exs")
Code.require_file("src/utils.exs")

defmodule EVM do
  use Opcodes

  def run(state, code) do
    step(state, code, [], 0)
  end

  def step(state, code, stack, program_counter) do
    opcode = :binary.at(code, program_counter)

    storage = state[:accounts]
      |> Storage.step(stack, opcode)
    stack = stack
      |> Stack.step(code, program_counter, opcode)
    Log.step(code, program_counter, opcode)

    state = state
      |> put_in([:accounts, state["address"], "storage"], storage)

    if program_counter + 1 < byte_size(code) do
      program_counter = next_instruction(program_counter, code, opcode)
      step(state, code, stack, program_counter)
    else
      state
    end
  end

  def next_instruction(program_counter, code, opcode) do
    cond do
      is_push_opcode(opcode) ->
        size = opcode - atom_to_opcode(:push1)
        program_counter + size + 1
      program_counter < byte_size(code) ->
        program_counter + 1
    end
  end
end