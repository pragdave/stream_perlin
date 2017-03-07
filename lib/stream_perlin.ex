defmodule StreamPerlin do

  @moduledoc """
  Generate a potentially infinite stream of floats betyween -1 and 1 which
  vary smoothly using a 1d Perlin algorithm.
  """
  
  # `g1` and `g2` are the gradients at the start and end of the
  # current unit line segment. There are `frequency` values generated
  # within each unit segment.
  #
  # We precalculate the values in a segment. This means we can discard
  # the low gradient each time we move to a new unit, so we
  # can generate an infinite stream in finite memory.
  
  defstruct g1: 0, g2: 0, values_in_unit: [], frequency: 5

  @doc """
  Return a stream of random-ish floats between -1 and 1, where the values
  tend to change smoothly. This is useful when generating data that
  is supposed to look natural.

  ### Usage

      StreamPerlin.generate(n)

  generates a stream of floats. `n` is the _frequency_, a positive integer.
  It determines the number of values that are interpolated between new 
  random points. The interpolation is eased using a quintic with zero first and 
  second derivatives at 0 and 1, ensuring the curve is continuous and smooth
  as it moves between random values.

  Good values of `n` depend on how jagged you want your data, and how many samples
  you typically take. Values between 5 and 20 seem like a good starting
  point.

  If you need more complex data, you can apply Perlin's _octaves_ technique.
  """
  def generate(frequency) when is_integer(frequency) and frequency >= 1 do
    state = %__MODULE__{
      g2: random_gradient(),
      frequency: frequency,
    }
    
    Stream.unfold(state, &generate_perlin/1)
  end

  ############################################################

  # For 1D curves, the gradient is just a value between -1 and 1.
  
  defp random_gradient() do
    :rand.uniform() * 2 - 1
  end

  # get here when we have to start a new unit. We shift the
  # gradients down to ensure a continuation of the
  # tangent
  defp generate_perlin(%{ values_in_unit: [], g2: g2, frequency: frequency }) do
    new_g2 = random_gradient()
    state = %__MODULE__{
      g1: g2,
      g2: new_g2,
      frequency: frequency,
      values_in_unit: generate_values_for_unit(g2, new_g2, frequency)
    }
    generate_perlin(state)
  end

  # here we're inside a unit, so, just return the next computed value
  defp generate_perlin(state = %{ values_in_unit: [ val | rest ] }) do
    { val, %{ state | values_in_unit: rest } }
  end


  
  defp generate_values_for_unit(g1, g2, frequency) do
    1..frequency
    |> Enum.map(&perlin_value(&1, frequency, g1, g2))
  end


  
  def perlin_value(offset, frequency, g1, g2) do
    offset = ease(offset / frequency)

    # contributions of the two end vectors to a point between them
    u = (1 - offset) * g1
    v = offset * g2
    lerp(u, v, offset)
  end

  
  # linear interpolation at a point `o` between `s` and `e`.
  defp lerp(s, e, o) do
    s + (e-s)*o
  end

  # Use the quintic easing from Perlin 2002: 6t^5-15t^4+10t^3
  
  defp ease(t) when t >= 0 and t <= 1 do
    ((6*t - 15) * t + 10) * t * t * t
  end
end
