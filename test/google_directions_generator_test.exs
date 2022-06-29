defmodule GoogleDirectionsGeneratorTest do
  use ExUnit.Case
  alias GoogleDirectionsGenerator.Http

  test "GoogleDirectionsGenerator.run()" do
    {status, _} = GoogleDirectionsGenerator.run()

    assert status == :ok
  end

  @tag timeout: 120_000
  test "GoogleDirectionsGenerator push to endpoint " do

    {_,origin} =  Http.fetch_lat_lng()

    destination_url = "127.0.0.1"
    count = 1
    delay = 1
    custom_params = []

    {status, _} =
      GoogleDirectionsGenerator.push(destination_url, %{count: count, delay: delay}, custom_params, origin)


    assert status == :error
  end
end
