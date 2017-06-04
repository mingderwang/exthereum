defmodule Stack do
  @push1_opcode 0x5f
  use Bitwise

  def step(stack, code, program_counter, opcode) do
    case opcode do
      opcode when opcode in @push1_opcode..@push1_opcode + 32 ->
        size = opcode - @push1_opcode
        value = code
          |> Kernel.binary_part(program_counter + 1, size)
          |> :binary.decode_unsigned


        IO.puts "PUSH" <> Integer.to_string(size)
        IO.puts "Value: " <> Integer.to_string(value)
        [value | stack]
      0x01 ->
        [left | [right | stack]] = stack
        IO.puts "ADD"
        [wrap(left + right) | stack]
      _->
        stack
    end
  end

  def encode(value) do
    "0x" <> (value |> :binary.encode_unsigned |> Base.encode16 |> String.downcase)
  end

  def wrap(value) do
    band(value, (:math.pow(2, 256)|> round) - 1)
  end
end
