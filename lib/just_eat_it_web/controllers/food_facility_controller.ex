defmodule JustEatItWeb.FoodFacilityController do
  use JustEatItWeb, :controller
  alias JustEatIt.Eats
  alias JustEatIt.Eats.FoodFacility
  require Logger

  action_fallback JustEatItWeb.FallbackController

  def index(conn, _params) do
    food_facilities = Eats.list_food_facilities()
    render(conn, :index, food_facilities: food_facilities)
  end

  def create(conn, %{"food_facility" => food_facility_params}) do
    with {:ok, %FoodFacility{} = food_facility} <- Eats.create_food_facility(food_facility_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/food_facilities/#{food_facility}")
      |> render(:show, food_facility: food_facility)
    end
  end

  def random(conn, params) do
    # TODO: better parsing of these params, using ecto types most likely, but this will do for something simple
    count = Map.get(params, "count", "5") |> String.to_integer() |> max(1)
    seed = Map.get(params, "seed")
    food_facilities = Eats.random_food_facilities(count, seed)
    render(conn, :index, food_facilities: food_facilities)
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    food_facility = Eats.get_food_facility!(id)
    render(conn, :show, food_facility: food_facility)
  end

  def update(conn, %{"id" => id, "food_facility" => food_facility_params}) do
    food_facility = Eats.get_food_facility!(id)

    with {:ok, %FoodFacility{} = food_facility} <- Eats.update_food_facility(food_facility, food_facility_params) do
      render(conn, :show, food_facility: food_facility)
    end
  end

  def delete(conn, %{"id" => id}) do
    food_facility = Eats.get_food_facility!(id)

    with {:ok, %FoodFacility{}} <- Eats.delete_food_facility(food_facility) do
      send_resp(conn, :no_content, "")
    end
  end
end
