defmodule JustEatItWeb.FoodFacilityControllerTest do
  use JustEatItWeb.ConnCase

  import JustEatIt.EatsFixtures

  alias JustEatIt.Eats.FoodFacility

  @create_attrs %{
    name: "some name",
    facility_type: :truck,
    address: "123 Test St.",
    menu_description: "Tacos and nothing but.",
    latitude: "37.755030726766726",
    longitude: "-122.38453073422282"
  }
  @update_attrs %{
    name: "some updated name",
    facility_type: :push_cart,
    address: "345 New Test St.",
    menu_description: "Salads, lots of salads.",
    latitude: 36.755030726766726,
    longitude: -121.38453073422282
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all food_facilities", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/food_facilities")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create food_facility" do
    test "renders food_facility when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/food_facilities", food_facility: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/food_facilities/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "facility_type" => "truck",
               "address" => "123 Test St.",
               "menu_description" => "Tacos and nothing but.",
               "latitude" => "37.755030726766726",
               "longitude" => "-122.38453073422282"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/food_facilities", food_facility: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update food_facility" do
    setup [:create_food_facility]

    test "renders food_facility when data is valid", %{conn: conn, food_facility: %FoodFacility{id: id} = food_facility} do
      conn = put(conn, ~p"/api/v1/food_facilities/#{food_facility}", food_facility: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/food_facilities/#{id}")

      assert %{
               "id" => ^id,
               "facility_type" => "push_cart",
               "address" => "345 New Test St.",
               "menu_description" => "Salads, lots of salads.",
               "latitude" => "36.755030726766726",
               "longitude" => "-121.38453073422282"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, food_facility: food_facility} do
      conn = put(conn, ~p"/api/v1/food_facilities/#{food_facility}", food_facility: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete food_facility" do
    setup [:create_food_facility]

    test "deletes chosen food_facility", %{conn: conn, food_facility: food_facility} do
      conn = delete(conn, ~p"/api/v1/food_facilities/#{food_facility}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/food_facilities/#{food_facility}")
      end
    end
  end

  defp create_food_facility(_) do
    food_facility = food_facility_fixture()
    %{food_facility: food_facility}
  end
end
