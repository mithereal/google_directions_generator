# GoogleDirectionsGenerator

[![Build Status](https://travis-ci.org/mithereal/google-directions-generator.svg?branch=master)](https://travis-ci.org/mithereal/google-directions-generator)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmithereal%2Fgoogle_directions_generator.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmithereal%2Fgoogle_directions_generator?ref=badge_shield)

[![Inline docs](http://inch-ci.org/github/mithereal/google-directions-generator.svg)](http://inch-ci.org/github/mithereal/google-directions-generator)


### This is an app for testing api's

#### This will use google locations to fetch the geo-coords for driving directions between random multiple locations near a ip geo location
###### This was created to simulate requests from a mobile device for a vehicle driving between multiple locations so we can send the geo-coords to an endpoint.

## Installation

If [available in Hex](https://hex.pm/packages/google_directions_generator), the package can be installed
by adding google_directions_generator to your list of dependencies in `mix.exs`:

you will need a google api key, you can add to your config ie. 
``` config :google_directions_generator, api_key:xxx ```

```elixir
def deps do
  [{:google_directions_generator, "~> 0.2.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/google_directions_generator](https://hexdocs.pm/google_directions_generator).



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmithereal%2Fgoogle_directions_generator.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmithereal%2Fgoogle_directions_generator?ref=badge_large)