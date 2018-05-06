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
end
