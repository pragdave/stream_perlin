defmodule StreamPerlinTest do
  use ExUnit.Case
  use Quixir
  
  test "the stream contains floats between -1 and 1" do
    ptest freq: int(min: 1, max: 50) do
      StreamPerlin.generate(freq)
      |> Enum.take(100)
      |> Enum.each(fn val ->
        assert is_float(val)
        assert val >= -1.0
        assert val <=  1.0
        end)
    end
  end
end
