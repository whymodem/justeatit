defmodule JustEatItWeb.FoodFacilityJSON do
  alias JustEatIt.Eats.FoodFacility

  @doc """
  Renders a list of food_facilities.
  """
  def index(%{food_facilities: food_facilities}) do
    %{data: for(food_facility <- food_facilities, do: data(food_facility))}
  end

  @doc """
  Renders a single food_facility.
  """
  def show(%{food_facility: food_facility}) do
    %{data: data(food_facility)}
  end

  defp data(%FoodFacility{} = food_facility) do
    %{
      id: food_facility.id,
      name: food_facility.name,
      facility_type: food_facility.facility_type,
      address: food_facility.address,
      latitude: food_facility.latitude,
      longitude: food_facility.longitude,
      menu_description: food_facility.menu_description
    }
  end
end
