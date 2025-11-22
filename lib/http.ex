defmodule GoogleDirectionsGenerator.Http do
  @moduledoc false
  use Tesla

  require Logger

  plug(Tesla.Middleware.BaseUrl, "https://maps.googleapis.com/")

  plug(Tesla.Middleware.Headers, [
    {"user-agent", "Elixir - Google Directions Generator"},
    {"Content-Type", "application/x-www-form-urlencoded"}
  ])

  @key Application.compile_env(:google_directions_generator, :api_key, "")

  def waypoints(%{origin: origin, destination: destination}) do
    post("maps/api/directions/json?origin#{origin}&destination=#{destination}&key=#{@key}", [])
  end

  def nearby_search(%{lat: lat, lng: lng, radius: radius, type: type}) do
    post(
      "maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{radius}&type=#{type}&key=#{@key}",
      []
    )
  end

  def fetch_lat_lng(ip \\ nil) do
    ip =
      case is_nil(ip) do
        true ->
          {_, reply} = Tesla.get("https://api.myip.com")
          {_, result} = Jason.decode(reply.body)
          result["ip"]

        false ->
          ip
      end

    Tesla.get("http://ipapi.co/#{ip}/json")
  end

  def push(url, params) do
    Logger.info("Request: #{url}")

    Tesla.post(url, params)
  end

  def geo_locate() do
    post("/geolocation/v1/geolocate?key=#{@key}", [])
  end
end
