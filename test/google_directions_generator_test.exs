defmodule GoogleDirectionsGeneratorTest do
  use ExUnit.Case
  doctest GoogleDirectionsGenerator

  test "GoogleDirectionsGenerator.run()" do
    coords = GoogleDirectionsGenerator.run()
    result = case Enum.count(coords) > 0 do
      true -> true
      _-> false
    end
    assert result == true
  end

  @tag timeout: 120000
  test "GoogleDirectionsGenerator push to endpoint " do
    url = "127.0.0.1"
    count = 1
    delay = 1
    custom_params = []
    origin = GoogleDirectionsGenerator.current_lat_long()

    res = GoogleDirectionsGenerator.push(url, %{ count: count, delay: delay }, custom_params, origin)

    result = case res do
      [:ok] -> true
      _-> false
    end
    assert result == false
  end
end
