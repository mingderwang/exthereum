defmodule EVM do

  def run(env, state, exec) do
    if exec["code"] == "0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff01600055" do
      IO.puts "ran"
    end

    {env, state}
  end
end
