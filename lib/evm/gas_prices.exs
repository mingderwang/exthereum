defmodule EVM.GasPrices do
  defmacro __using__(_opts) do
    quote do
      @gas_prices %{
        add: 3,
        push1: 3,
        push32: 3,
        sstore: 20000,
      }
    end
  end
end
