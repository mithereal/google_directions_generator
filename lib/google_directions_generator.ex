defmodule GoogleDirectionsGenerator do
  @moduledoc """
  Generate Geoocords for random locations located nearby
  """

  alias GoogleDirectionsGenerator.Http

  @types [
    "accounting",
    "airport",
    "amusement_park",
    "aquarium",
    "art_gallery",
    "atm",
    "bakery",
    "bank",
    "bar",
    "beauty_salon",
    "bicycle_store",
    "book_store",
    "bowling_alley",
    "bus_station",
    "cafe",
    "campground",
    "car_dealer",
    "car_rental",
    "car_repair",
    "car_wash",
    "casino",
    "cemetery",
    "church",
    "city_hall",
    "clothing_store",
    "convenience_store",
    "courthouse",
    "dentist",
    "department_store",
    "doctor",
    "electrician",
    "electronics_store",
    "embassy",
    "fire_station",
    "florist",
    "funeral_home",
    "furniture_store",
    "gas_station",
    "gym",
    "hair_care",
    "hardware_store",
    "hindu_temple",
    "home_goods_store",
    "hospital",
    "insurance_agency",
    "jewelry_store",
    "laundry",
    "lawyer",
    "library",
    "liquor_store",
    "local_government_office",
    "locksmith",
    "lodging",
    "meal_delivery",
    "meal_takeaway",
    "mosque",
    "movie_rental",
    "movie_theater",
    "moving_company",
    "museum",
    "night_club",
    "painter",
    "park",
    "parking",
    "pet_store",
    "pharmacy",
    "physiotherapist",
    "plumber",
    "police",
    "post_office",
    "real_estate_agency",
    "restaurant",
    "roofing_contractor",
    "rv_park",
    "school",
    "shoe_store",
    "shopping_mall",
    "spa",
    "stadium",
    "storage",
    "store",
    "subway_station",
    "synagogue",
    "taxi_stand",
    "train_station",
    "transit_station",
    "travel_agency",
    "university",
    "veterinary_care",
    "zoo"
  ]

  @doc """
  ## Run The Module and return a list of driving coords based on a nearby random location
  """
  def run do
    random
  end

  @doc """
  ## Send to the endpoint
  """
  def push(url, %{count: count, delay: delay}) do
    reply = Http.fetch_lat_lng()

    my_coords = decode_lat_long(reply)

    params = ["lat=#{my_coords.lat}", "lng=#{my_coords.lng}"]

    Http.push(url, Enum.join(params, "&"))

    for _ <- 1..count do
      {_, trip_coords} = random

      Enum.each(trip_coords, fn x ->
        params = ["lat=#{x.start_location.lat}", "lng=#{x.start_location.lng}"]

        Http.push(url, Enum.join(params, "&"))

        :timer.sleep(:timer.seconds(:rand.uniform(delay)))

        params = ["lat=#{x.end_location.lat}", "lng=#{x.end_location.lng}"]

        Http.push(url, Enum.join(params, "&"))

        :timer.sleep(:timer.seconds(:rand.uniform(delay)))
      end)
    end
  end

  def push(url, %{count: count, delay: delay}, custom_params) do
    reply = Http.fetch_lat_lng()

    my_coords = decode_lat_long(reply)

    params = ["lat=#{my_coords.lat}", "lng=#{my_coords.lng}"]

    custom_params_list =
      Enum.map(custom_params, fn x ->
        {key, val} = x

        key <> "=" <> val
      end)

    params = Enum.concat(custom_params_list, params)


    Http.push(url, Enum.join(params, "&"))

    for _ <- 1..count do
      {_, trip_coords} = random

      Enum.each(trip_coords, fn x ->
        params = ["lat=#{x.start_location.lat}", "lng=#{x.start_location.lng}"]
        params = Enum.concat(custom_params_list, params)

        Http.push(url, Enum.join(params, "&"))

        :timer.sleep(:timer.seconds(:rand.uniform(delay)))

        Http.push(url, Enum.join(params, "&"))

        :timer.sleep(:timer.seconds(:rand.uniform(delay)))
      end)
    end
  end

  def push(url, %{count: count, delay: delay}, custom_params, origin) do

    params = ["lat=#{origin.lat}", "lng=#{origin.lng}"]

    custom_params_list =
      Enum.map(custom_params, fn x ->
        {key, val} = x

        key <> "=" <> val
      end)

    params = Enum.concat(custom_params_list, params)

    Http.push(url, Enum.join(params, "&"))

    for _ <- 1..count do
      {status, trip_coords} = random

      case status do
        :ok ->
          Enum.each(trip_coords, fn x ->
            params = ["lat=#{x.start_location.lat}", "lng=#{x.start_location.lng}"]
            params = Enum.concat(custom_params_list, params)

            Http.push(url, Enum.join(params, "&"))

            :timer.sleep(:timer.seconds(:rand.uniform(delay)))

            params = ["lat=#{x.end_location.lat}", "lng=#{x.end_location.lng}"]
            params = Enum.concat(custom_params_list, params)

            Http.push(url, Enum.join(params, "&"))

            :timer.sleep(:timer.seconds(:rand.uniform(delay)))
          end)

        :error ->
          {:error, trip_coords}
      end
    end
  end

  @doc """
  ## Get a random place geocoords based on starting location
  """
  def random(radius \\ 5000) do

    result = Http.geo_locate()

    decoded = Jason.decode!(result.body)

    error = decoded["error"]

    case error do
      nil ->
        coords = decoded["location"]

        lat = to_string(coords["lat"])
        lng = to_string(coords["lng"])

        type = Enum.random(@types)

        params = %{lat: lat, lng: lng, radius: radius, type: type}

        result = Http.nearby_search(params)

        decoded_json = Jason.decode!(result.body)

        reply =
          case decoded_json do
            %{"html_attributions" => [], "results" => [], "status" => "ZERO_RESULTS"} ->
              {status, reply} = random

              result =
                case status do
                  :ok -> reply
                  :error -> []
                end

            _ ->
              decoded_json["results"]
          end

        locations =
          Enum.map(reply, fn x ->
            get_coords(x)
          end)

         create_route(locations)

      _ ->
        {:error, error["message"]}
    end
  end

  @doc """
  ## Get coordinates from a location result
  """
  def get_coords(data) do
    case data do
      %{lat: lat, lng: lng, name: name} ->
        data

      _ ->
        geometry = data["geometry"]
        coords = geometry["location"]
        name = data["name"]
        vicinity = data["vicinity"]

        %{name: name, lat: coords["lat"], lng: coords["lng"], vicinity: vicinity}
    end
  end

  @doc """
  ## Create a driving route from location coords
  """
  def create_route(locations \\ []) do

    case(Enum.count(locations) > 1) do
      true ->
        [origin|destination] = Enum.chunk(locations, 2)


        result = Http.waypoints(%{origin: origin, destination: destination})
        json = result.body
        waypoints_json = Jason.decode!(json)
        [routes] = waypoints_json["routes"]
        legs = routes["legs"]

        steps =
          Enum.map(legs, fn x ->
            x["steps"]
          end)

        waypoints =
          List.flatten(steps)
          |> Enum.map(fn x ->
            start_loc = Map.get(x, "start_location")
            start_map = %{lat: start_loc["lat"], lng: start_loc["lng"]}
            end_loc = Map.get(x, "end_location")
            end_map = %{lat: end_loc["lat"], lng: end_loc["lng"]}
            %{start_location: start_map, end_location: end_map}
          end)

        {:ok, waypoints}

      false ->
        {:error, "Locations must be greater then 2"}
    end
  end

  @doc """
  ## get the coords of the current server
  """
  def decode_lat_long(data) do
    decoded = Jason.decode(data)

    is_json =
      case decoded do
        {:error, msg} -> false
        _ -> true
      end

    return =
      case is_json do
        false ->
          %{lat: 0, lng: 0}

        true ->
          lat = to_string(decoded["latitude"])
          lng = to_string(decoded["longitude"])
          region = to_string(decoded["region"])
          region_code = to_string(decoded["region_code"])
          country = to_string(decoded["country"])
          country_name = to_string(decoded["country_name"])
          postal = to_string(decoded["postal"])
          timezone = to_string(decoded["timezone"])
          asn = to_string(decoded["asn"])
          org = to_string(decoded["org"])

          %{lat: lat, lng: lng}
      end
  end
end
