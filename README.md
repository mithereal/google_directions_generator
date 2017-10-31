# GoogleDirectionsGenerator

[![Build Status](https://travis-ci.org/mithereal/google-directions-generator.svg?branch=master)](https://travis-ci.org/mithereal/google-directions-generator)


### This is an app for testing api's

#### This will use google locations to fetch the geo-coords for driving directions between random multiple locations near you
###### This was created to simulate a vehicle driving between multiple locations so we can send the geo-coords to an endpoint

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `google_directions_generator` to your list of dependencies in `mix.exs`:

you will need a google api key, you can add to your config ie. ' config :google_directions_generator, api_key:xxx '

```elixir
def deps do
  [{:google_directions_generator, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/google_directions_generator](https://hexdocs.pm/google_directions_generator).

