defmodule GoogleDirectionsGenerator.Http do
  @moduledoc false
  use Tesla

  require Logger

  plug(Tesla.Middleware.BaseUrl, "https://maps.googleapis.com/")

  plug(Tesla.Middleware.Headers, [
    {"user-agent", "Elixir - Google Directions Generator"},
    {"Content-Type", "application/x-www-form-urlencoded"}
  ])

  @key Application.get_env(:google_directions_generator, :api_key, "")

  def waypoints(%{origin: origin, destination: destination}) do
    post("maps/api/directions/json?origin#{origin}&destination=#{destination}&key=#{@key}", [])
  end

  def nearby_search(%{lat: lat, lng: lng, radius: radius, type: type}) do
    post(
      "maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{radius}&type=#{type}&key=#{@key}", []
    )
  end

  def fetch_lat_lng() do
    {_, reply} = Tesla.get("https://api.myip.com")
    {_, reply} = Jason.decode(reply.body)
    {_, ip_address} = Tesla.get("http://ipapi.co/#{reply["ip"]}/json")
    Tesla.get("http://ipapi.co/#{ip_address}/json")
  end

  def push(url, params) do
    Logger.info("Request: #{url}")

    Tesla.post(url, params)
  end

  def geo_locate() do
    post("/geolocation/v1/geolocate?key=#{@key}", [])
  end
end
