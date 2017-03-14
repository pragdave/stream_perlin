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

  test "we can call the generator manually" do
    sp = StreamPerlin.initialize(100)  # with a long cycle, values should be close
    { v1, sp } = StreamPerlin.next(sp)
    { v2, sp } = StreamPerlin.next(sp)
    { v3, sp } = StreamPerlin.next(sp)
    { v4, _  } = StreamPerlin.next(sp)

    assert v1 != v2
    assert v2 != v3
    assert v3 != v4

    assert abs(v1-v2) < 2/50
    assert abs(v2-v3) < 2/50
    assert abs(v3-v4) < 2/50
  end
end
