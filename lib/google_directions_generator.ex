defmodule GoogleDirectionsGenerator do
  @moduledoc """
  Generate Geoocords for random locations located nearby
  """

  @doc """
  ## Run The Module

  """

  @types  [
"accounting", "airport", "amusement_park", "aquarium", "art_gallery", "atm", "bakery", "bank", "bar", "beauty_salon", "bicycle_store", "book_store", "bowling_alley", "bus_station", "cafe", "campground", "car_dealer", "car_rental", "car_repair", "car_wash", "casino", "cemetery", "church", "city_hall", "clothing_store", "convenience_store", "courthouse", "dentist", "department_store", "doctor", "electrician", "electronics_store", "embassy", "fire_station", "florist", "funeral_home", "furniture_store", "gas_station", "gym", "hair_care", "hardware_store", "hindu_temple", "home_goods_store", "hospital", "insurance_agency", "jewelry_store", "laundry", "lawyer", "library", "liquor_store", "local_government_office", "locksmith", "lodging", "meal_delivery", "meal_takeaway", "mosque", "movie_rental", "movie_theater", "moving_company", "museum", "night_club", "painter", "park", "parking", "pet_store", "pharmacy", "physiotherapist", "plumber", "police", "post_office", "real_estate_agency", "restaurant", "roofing_contractor", "rv_park", "school", "shoe_store", "shopping_mall", "spa", "stadium", "storage", "store", "subway_station", "synagogue", "taxi_stand", "train_station", "transit_station", "travel_agency", "university", "veterinary_care", "zoo"
  ]


  def run do
    random
  end

  @doc """
  ## Send to the endpoint
  """
  def push(url, %{ count: count, delay: delay } \\ %{ count: 1, delay: 5 }) do
    my_coords = current_lat_long()

    headers = ["User-Agent": "Elixir",
            "Content-Type": "application/x-www-form-urlencoded"]

      params = ["lat=#{my_coords.lat}", "lng=#{my_coords.lng}"]

      IO.puts "posting to " <> url

      HTTPotion.post url , [body: Enum.join(params, "&"), headers: headers]

for _ <- 1..count do

    trip_coords = random

    Enum.each(trip_coords, fn(x) ->

        params = ["lat=#{x.start_location.lat}", "lng=#{x.start_location.lng}"]

        IO.puts "posting to " <> url

        HTTPotion.post url , [body: Enum.join(params, "&"), headers: headers]

        :timer.sleep(:timer.seconds(:rand.uniform(delay)))

        params = ["lat=#{x.end_location.lat}", "lng=#{x.end_location.lng}"]

        HTTPotion.post url , [body: Enum.join(params, "&"), headers: headers]

         :timer.sleep(:timer.seconds(:rand.uniform(delay)))
    end)

end
  end

  @doc """
    ## Send to the endpoint
    """
    def push(url, %{ count: count, delay: delay }, custom_params) do
      my_coords = current_lat_long()

      headers = ["User-Agent": "Elixir",
              "Content-Type": "application/x-www-form-urlencoded"]

        params = ["lat=#{my_coords.lat}", "lng=#{my_coords.lng}"]

        IO.inspect(custom_params, label: "custom_params is ")

        custom_params_list= Enum.map(custom_params, fn(x) ->

        IO.inspect(x, label: "x is ")

#        [k] = Map.keys(x)
#        %{key: val} = x
#        k <> "=" <> val
        end)

         params = Enum.join(custom_params_list, params)

        IO.puts "posting to " <> url

        HTTPotion.post url , [body: Enum.join(params, "&"), headers: headers]

  for _ <- 1..count do

      trip_coords = random

      Enum.each(trip_coords, fn(x) ->

          params = ["lat=#{x.start_location.lat}", "lng=#{x.start_location.lng}"]

          IO.puts "posting to " <> url

          HTTPotion.post url , [body: Enum.join(params, "&"), headers: headers]

          :timer.sleep(:timer.seconds(:rand.uniform(delay)))

          params = ["lat=#{x.end_location.lat}", "lng=#{x.end_location.lng}"]

          HTTPotion.post url , [body: Enum.join(params, "&"), headers: headers]

           :timer.sleep(:timer.seconds(:rand.uniform(delay)))
      end)

  end
    end

  @doc """
  ## Get a random place geocoords based on starting location
  """
  def random do

    key = Application.get_env(:google_directions_generator, :api_key)
    url = "https://www.googleapis.com/geolocation/v1/geolocate?key=" <> key
    result = HTTPotion.post url
    json = result.body

    decoded = Poison.decode!(json)
    coords = decoded["location"]

    lat = to_string coords["lat"]
    lng = to_string coords["lng"]

    type = Enum.random(@types)

    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" <> lat <> "," <> lng <> "&radius=5000&type="<> type <>"&key=" <> key
    result = HTTPotion.post url
    json = result.body

    decoded_json = Poison.decode!(json)

    reply = case decoded_json do
      %{"html_attributions" => [], "results" => [], "status" => "ZERO_RESULTS"} -> random
      _-> decoded_json["results"]
    end

    locations  = Enum.map(reply, fn(x) ->
    get_coords(x)
    end)


     create_route(locations)
  end

  @doc """
  ## Get coordinates from a location result
  """
def get_coords(loc)do

case loc do
  %{ lat: lat, lng: lng, name: name } -> loc
  _-> geometry = loc["geometry"]
      coords = geometry["location"]
      name = loc["name"]

      %{ name: name, lat: coords["lat"], lng: coords["lng"] }

end

end

  @doc """
  ## Create a driving route from location coords
  """
def create_route(locations) do
 key = Application.get_env(:google_directions_generator, :api_key)

chunked_locations = Enum.chunk(locations, 2)

url = "https://maps.googleapis.com/maps/api/directions/json?origin=Boston,MA&destination=Concord,MA&waypoints=Charlestown,MA&key=" <> key
 result = HTTPotion.post url
    json = result.body
    waypoints_json = Poison.decode!(json)
    [routes] = waypoints_json["routes"]
    legs = routes["legs"]

   steps = Enum.map(legs, fn(x) ->
    x["steps"]
   end)

    waypoints = List.flatten(steps)
      |> Enum.map(fn(x) ->
      start_loc = Map.get(x, "start_location")
      start_map = %{ lat: start_loc["lat"], lng: start_loc["lng"] }
      end_loc = Map.get(x, "end_location")
      end_map = %{ lat: end_loc["lat"], lng: end_loc["lng"] }
     %{ start_location: start_map, end_location: end_map }
      end)

end

  @doc """
  ## get the coords of the current server
  """
def current_lat_long() do
url = "https://ipapi.co/8.8.8.8/json"
result = HTTPotion.get url
json = result.body

  decoded = Poison.decode!(json)

  lat = to_string decoded["latitude"]
  lng = to_string decoded["longitude"]

  %{lat: lat, lng: lng }
end

end
