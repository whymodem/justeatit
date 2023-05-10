defmodule JustEatIt.Eats.External.SFGov.MobileFoodFacilityCodec do
  @moduledoc """
  Used for conversions between local types and external types coming from https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data.

  A JSON version of the above is available at https://data.sfgov.org/resource/rqzj-sfat.json.

  The data is a bit messy and requires some massaging, which is encapsulated in this module. We take only the fields we are interested in and try to convert as a tolerant reader.any()
  """
  alias JustEatIt.Eats.FoodFacility

  #TODO: It would be better to rename decode to decode! or have decode return an {:ok, result} format for decoding, but currently there's not really anything we allow failure on anyway worth handling

  @doc """
  Given JSON from https://data.sfgov.org/resource/rqzj-sfat.json, decode it into an Ecto `FoodFacility`
  """
  def decode(food_facility_json) do
    Enum.map(food_facility_json, fn food_facility ->
      # TODO: this needs some additional mapping steps and validation, probably using ecto,
      # so leaving this as a fn instead of calling with function reference syntax above to make it easier to change
      decode_food_facility(food_facility)
    end)
  end

  @doc """
  Given JSON from https://data.sfgov.org/resource/rqzj-sfat.json, decode it into an Ecto `FoodFacility`
  """
  def decode_food_facility(food_facility) do
    # This maps a single json item to a map that can be cast to an ecto changeset
    data = %{
      name: food_facility["applicant"],
      facility_type: food_facility["facilitytype"] |> decode_facility_type,
      menu_description: food_facility["fooditems"] |> decode_food_items,
      address: food_facility["address"],
      latitude: food_facility["latitude"] |> decode_latitude,
      longitude: food_facility["longitude"] |> decode_longitude,
      external_id: food_facility["objectid"]
    }

    Ecto.Changeset.cast(%FoodFacility{}, data, Map.keys(data))
    |> Ecto.Changeset.apply_changes()
  end

  defp decode_facility_type("Truck") do
    :truck
  end

  defp decode_facility_type("Push Cart") do
    :push_cart
  end

  defp decode_facility_type(_) do
    nil
  end

  defp decode_latitude("0") do
    nil
  end

  defp decode_latitude(latitude) do
    latitude
  end

  defp decode_longitude("0") do
    nil
  end

  defp decode_longitude(longitude) do
    longitude
  end

  defp decode_food_items(nil) do
    nil
  end

  defp decode_food_items(food_items) do
    # TODO: this can be expanded upon as there are surely additional cases of weird data, however this was the most glaring
    String.trim(food_items, ":") |> String.replace(":", ",")
  end
end
