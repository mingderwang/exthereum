Code.require_file("src/opcodes.exs")
Code.require_file("src/utils.exs")

defmodule Log do
  use Opcodes
  use Utils

  def step(code, program_counter, opcode) do
    log_opcode(opcode)

    if is_push_opcode(opcode) do
      value = value_at(code, program_counter, opcode)
      IO.puts "Value: " <> encode(value)
    end
  end

  def log_opcode(opcode) do
    IO.puts @opcodes[opcode]
      |> Atom.to_string
      |> String.upcase
  end

  def log(value) do
    IO.puts(value)
  end
end
