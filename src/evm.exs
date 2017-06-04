Code.require_file("src/stack.exs")
Code.require_file("src/storage.exs")

defmodule EVM do
  @push1_opcode 0x5f


  def run(state, code) do
    step(state, code, [], 0)
  end

  def step(state, code, stack, program_counter) do
    opcode = :binary.at(code, program_counter)

    storage = state[:accounts]
      |> Storage.step(stack, opcode, state["address"])
    state = state
      |> put_in([:accounts], storage)

    stack = stack
      |> Stack.step(code, program_counter, opcode)


    if program_counter + 1 < byte_size(code) do
      program_counter = next_instruction(program_counter, code, opcode)
      step(state, code, stack, program_counter)
    else
      state
    end
  end

  def next_instruction(program_counter, code, opcode) do
    cond do
      opcode in @push1_opcode..@push1_opcode + 32 ->
        size = opcode - @push1_opcode
        program_counter + size
      program_counter < byte_size(code) ->
        program_counter + 1
    end
  end
end
