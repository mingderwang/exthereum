defmodule EVM do
  use Bitwise
  @push1_opcode 0x5f


  def run(state, code) do
    state = Map.merge(%{
      program_counter: 0,
      stack: [],
      storage: {},
    }, state)

    state = step(state, code)
    state = update_in(state, [:program_counter], &(&1 + 1))

    if state[:program_counter] < byte_size(code) do
      EVM.run(state, code)
    else
      state
    end
  end

  def step(state, code) do
    case :binary.at(code, state[:program_counter]) do
      opcode when opcode in @push1_opcode..@push1_opcode + 32 ->
        size = opcode - @push1_opcode
        value = code
          |> Kernel.binary_part(state[:program_counter] + 1, size)
          |> :binary.decode_unsigned


        IO.puts "PUSH" <> Integer.to_string(size)
        IO.puts "Value: " <> Integer.to_string(value)
        state = update_in(state, [:program_counter], &(&1 + size))
        %{state | stack: [value | state[:stack]]}
      0x01 ->
        [left | [right | stack]] = state[:stack]
        big = (:math.pow(2, 256)|> round) - 1
        IO.puts "ADD"
        %{state | stack: [band((left + right), big) | stack]}
      0x55 ->
        [register | [value | stack]] = state[:stack]
        register = "0x" <> (register |> :binary.encode_unsigned |> Base.encode16 |> String.downcase)
        value = "0x" <> (value |> :binary.encode_unsigned |> Base.encode16 |> String.downcase)
        store = %{register => value}
        state = %{state | stack: stack}
        state = put_in(state, [:addresses, state["address"], "storage"], store)
        IO.puts "SSTORE"
        state
      _->
        state
    end
  end
end
