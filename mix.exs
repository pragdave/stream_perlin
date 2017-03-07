defmodule StreamPerlin.Mixfile do
  use Mix.Project

  @version  "0.1.0"
  @deps [
    { :quixir, ">= 0.0.0", only: :test },
    { :ex_doc, ">= 0.0.0", only: :dev  },    
  ]

  @description """
  Generate a stream of random-ish floats between -1 and 1 using the Perlin
  algorithm. When plotted, the points will tend to form a smooth curve. 
  This is useful when generating mock values that are supposed to be "natural."
  """
  
  ############################################################
  
  def project do
    in_production =  Mix.env == :prod
    [
      app:     :stream_perlin,
      version: @version,
      deps:    @deps,
      package: package(),
      elixir:  "~> 1.5-dev",
      description:     @description,
      build_embedded:  in_production,
      start_permanent: in_production,
    ]
  end

  def application, do: []

  defp package do
    [
      files: [
        "lib", "mix.exs", "README.md", "LICENSE.md"
      ],
      maintainers: [
        "Dave Thomas <dave@pragdave.me>"
      ],
      licenses: [
        "Apache 2 (see the file LICENSE.md for details)"
      ],
      links: %{
        "GitHub" => "https://github.com/pragdave/stream_perlin",
      }
    ]
  end  
  
end
