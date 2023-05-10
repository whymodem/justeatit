defmodule JustEatIt.EatsTest do
  use JustEatIt.DataCase

  alias JustEatIt.Eats

  describe "food_facilities" do
    alias JustEatIt.Eats.FoodFacility

    import JustEatIt.EatsFixtures

    @invalid_attrs %{name: nil}

    test "list_food_facilities/0 returns all food_facilities" do
      food_facility = food_facility_fixture()
      assert Eats.list_food_facilities() == [food_facility]
    end

    test "get_food_facility!/1 returns the food_facility with given id" do
      food_facility = food_facility_fixture()
      assert Eats.get_food_facility!(food_facility.id) == food_facility
    end

    test "create_food_facility/1 with valid data creates a food_facility" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %FoodFacility{} = food_facility} = Eats.create_food_facility(valid_attrs)
      assert food_facility.name == "some name"
    end

    test "create_food_facility/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Eats.create_food_facility(@invalid_attrs)
    end

    test "update_food_facility/2 with valid data updates the food_facility" do
      food_facility = food_facility_fixture()

      update_attrs = %{
        name: "some updated name",
        facility_type: :push_cart,
        address: "345 New Test St.",
        menu_description: "Salads, lots of salads.",
        latitude: "36.755030726766726",
        longitude: "-121.38453073422282"
      }

      assert {:ok, %FoodFacility{} = food_facility} = Eats.update_food_facility(food_facility, update_attrs)
      assert food_facility.name == "some updated name"
      assert food_facility.facility_type == :push_cart
      assert food_facility.address == "345 New Test St."
      assert food_facility.menu_description == "Salads, lots of salads."
      assert food_facility.latitude == Decimal.new("36.755030726766726")
      assert food_facility.longitude == Decimal.new("-121.38453073422282")
    end

    test "update_food_facility/2 with invalid data returns error changeset" do
      food_facility = food_facility_fixture()
      assert {:error, %Ecto.Changeset{}} = Eats.update_food_facility(food_facility, @invalid_attrs)
      assert food_facility == Eats.get_food_facility!(food_facility.id)
    end

    test "delete_food_facility/1 deletes the food_facility" do
      food_facility = food_facility_fixture()
      assert {:ok, %FoodFacility{}} = Eats.delete_food_facility(food_facility)
      assert_raise Ecto.NoResultsError, fn -> Eats.get_food_facility!(food_facility.id) end
    end

    test "change_food_facility/1 returns a food_facility changeset" do
      food_facility = food_facility_fixture()
      assert %Ecto.Changeset{} = Eats.change_food_facility(food_facility)
    end
  end
end
