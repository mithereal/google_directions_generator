defmodule GoogleDirectionsGenerator.Mixfile do
  use Mix.Project

 @version "0.1.0"

  def project do
    [
    app: :google_directions_generator,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     name: "Google Directions Generator",
     source_url: "https://github.com/mithereal/google_directions_generator",
     aliases: aliases(),
     package: package()
     ]
  end


  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
    {:google_maps, git: "https://github.com/elixir-twister/ex_maps.git"},
    {:httpotion, "~> 3.0.2"},
    {:poison, "~> 2.0"},
    {:ex_doc, ">= 0.0.0", only: :dev},
    {:inch_ex, only: :docs}
    ]
  end

    defp description() do
      """
      use google locations to create geocoords for driving directions between multiple locations and send them to your api.
      """
    end

    defp package() do
      [maintainers: ["Jason Clark"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/mithereal/google_directions_generator"}]
    end

    defp aliases() do
            [c: "compile"]
      end

end
