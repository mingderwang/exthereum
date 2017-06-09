defmodule Exthereum.EVM.Utils do
  use Bitwise

  defmacro __using__(_opts) do
    quote do
      # credo:disable-for-next-line Credo.Check.Readability.MaxLineLength
      @max_int 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

      def value_at(code, program_counter, opcode) do
        size = size_of_push(opcode)
        code
          |> Kernel.binary_part(program_counter + 1, size)
          |> :binary.decode_unsigned
      end

      def size_of_push(opcode) do
        opcode - (atom_to_opcode(:push1) - 1)
      end


      def mod(_, 0), do: 0
      def mod(left, right), do: rem(left, right)

      # Append to the beginning of the list because its faster
      # https://hexdocs.pm/elixir/List.html

      def stack_push(stack, value) do
        [value | stack]
      end

      def stack_pop(stack) do
       List.pop_at(stack, 0)
      end

      def encode(value) do
        encoded_value =
          value
          |> :binary.encode_unsigned
          |> Base.encode16
          |> String.downcase

        "0x" <> encoded_value
      end

      def to_signed(i) do
        <<sign :: size(1), _ :: bitstring>> = :binary.encode_unsigned(i)
        if sign == 0, do: i, else: i - (@max_int + 1)
      end

      def to_unsigned(i) when i < 0 do
        @max_int - abs(i) + 1
      end

      def to_unsigned(i), do: i

      def pretty_encode(value) do
        encode(value) <> " (" <> Integer.to_string(value) <> ")"
      end

      def wrap(value) do
        band(value, (round(:math.pow(2, 256)) - 1))
      end
    end
  end
end
