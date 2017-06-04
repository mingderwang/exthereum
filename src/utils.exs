defmodule Utils do
  use Bitwise

  defmacro __using__(_opts) do
    quote do
      def value_at(code, program_counter, opcode) do
        size = opcode - atom_to_opcode(:push1)
        code
          |> Kernel.binary_part(program_counter + 1, size)
          |> :binary.decode_unsigned
      end

      def encode(value) do
        "0x" <> (value |> :binary.encode_unsigned |> Base.encode16 |> String.downcase)
      end

      def wrap(value) do
        band(value, (:math.pow(2, 256)|> round) - 1)
      end
    end
  end
end
