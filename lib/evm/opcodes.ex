defmodule Exthereum.EVM.Opcodes do
  defmacro __using__(_opts) do
    quote do
      @push_opcodes 0x60..0x7f
      @opcodes %{
        0x01 => :add,
        0x03 => :sub,
        0x06 => :mod,
        0x07 => :smod,
        0x08 => :addmod,
        0x14 => :eq,
        0x55 => :sstore,
        0x60 => :push1,
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
