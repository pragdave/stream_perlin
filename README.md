# StreamPerlin

Create a stream of random floats between -1.0 and 1.0 using the Perlin 
algorithm in one dimension. This smooths out the numbers, so that 
if plotted they'll tend to look like a more natural, smooth curve.

# Usage

The only parameter is the frequency, which basically determines how many points 
are interpolated before a new random value is generated. Higher values lead to 
smoother, and considerably less random, curves. 

     StreamPerlin.generate(5) |> Enum.take(20)
     
Create a set of 20 floats. The values will smoothly move between random numbers 
at every 5th value.


## Installation

```elixir
def deps do
  [
    stream_perlin:  "~> 0.1.0"
  ]
end
```

### License

Copyright © 2017 Dave Thomas <dave@pragdave.me>

Available under an Apache license. See [LICENSE.md](./LICENSE.md) for details
