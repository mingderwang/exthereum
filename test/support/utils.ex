defmodule Test.Utils do
  defmacro __using__(_opts) do
    quote do
      def hex_to_binary(string) do
        string
        |> String.slice(2..-1)
        |> Base.decode16!(case: :mixed)
      end

      def hex_to_int(string) do
        hex_to_binary(string)
        |> :binary.decode_unsigned
      end
    end
  end
end
