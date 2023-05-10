defmodule JustEatIt.EatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JustEatIt.Eats` context.
  """

  @doc """
  Generate a food_facility.
  """
  def food_facility_fixture(attrs \\ %{}) do
    {:ok, food_facility} =
      attrs
      |> Enum.into(%{
        name: "some name",
        facility_type: :truck,
        address: "123 Test St.",
        menu_description: "Tacos and nothing but.",
        latitude: "37.755030726766726",
        longitude: "-122.38453073422282"
      })
      |> JustEatIt.Eats.create_food_facility()

    food_facility
  end
end
