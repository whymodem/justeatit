defmodule JustEatIt.Seed.FoodFacility do
  @moduledoc """
  Imports external food facility JSON from SF Gov as seed data for the database.
  """

  alias JustEatIt.Repo
  alias JustEatIt.Eats.External.SFGov.MobileFoodFacilityCodec

  def seed! do
    # realistically, we could do a web request here, but that makes things like deploy dependent on the
    #SF Mobile Food Facility Permit endpoint being actually "up" if we want to seed data
    json_path = Path.join(:code.priv_dir(:just_eat_it), "data/seed/sf_mobile_food_facility_permits.json")
    with {:ok, file} <- File.read(json_path),
      {:ok, food_facility_json} <- Jason.decode(file),
      food_facility_json <- Enum.filter(food_facility_json, fn facility ->
        Map.get(facility, "status") == "APPROVED"
      end)
      do
        MobileFoodFacilityCodec.decode(food_facility_json)
        |> Enum.each(fn food_facility ->
          Repo.insert!(food_facility)
      end)
    end
  end
end
