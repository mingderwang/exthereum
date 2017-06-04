Code.require_file("lib/evm/opcodes.exs")
Code.require_file("lib/evm/utils.exs")

defmodule EVM.Log do
  use EVM.Opcodes
  use EVM.Utils

  def step(code, program_counter, opcode) do
    log_opcode(opcode)

    if is_push_opcode(opcode) do
      log_push_value(code, program_counter, opcode)
    end
  end

  def log_opcode(opcode) do
    log @opcodes[opcode]
      |> Atom.to_string
      |> String.upcase
  end

  def log_push_value(code, program_counter, opcode) do
    value = value_at(code, program_counter, opcode)
    log "VALUE: " <> encode(value)
  end

  def log(value) do
    IO.puts(value)
  end
end
