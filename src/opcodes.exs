defmodule Opcodes do
  defmacro __using__(_opts) do
    quote do
      @push_opcodes 0x5f..0x7f
      @opcodes %{
        0x01 => :add,
        0x55 => :sstore,
        0x5f => :push1,
        0x7f => :push32,
      }

      def is_push_opcode(opcode) do
        Enum.member?(@push_opcodes, opcode)
      end

      def atom_to_opcode(atom) do
        @opcodes
          |> Enum.find(fn {key, val} -> val == atom end)
          |> elem(0)
      end
    end
  end
end
