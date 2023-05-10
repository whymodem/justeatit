defmodule JustEatIt.Eats.FoodFacility do
  @moduledoc """
  A food facility is a location where someone can eat, for example a food truck, cart, or other type in the future.any()

  Each facility may have an option external id which can be used to tie it back to imported data.
  For instance, this can be used to refresh data from an external API without extensive matching logic, and is also useful for mash-ups.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_facilities" do
    field :name, :string

    # In the future, more types would be added, ex: stand, restaurant/free-standing, etc. if more than just SF mobile supported
    field :facility_type, Ecto.Enum, values: [truck: 1, push_cart: 2]
    field :menu_description, :string
    field :address, :string
    # Future: we will convert this to proper geo types if prudent such as Points with srids
    field :latitude, :decimal
    field :longitude, :decimal
    field :external_id, :string

    timestamps()
  end

  @doc false
  def changeset(food_facility, attrs) do
    food_facility
    |> cast(attrs, [:name, :facility_type, :menu_description, :address, :latitude, :longitude, :external_id])
    |> validate_required([:name])
  end

  @doc """
  Creates a friendly version of the food facilities that doesn't need to match what is defined on the ecto enum.

  Useful for display and more user friendly output.
  """
  def friendly_facility_type(facility_type) when is_atom(facility_type) do
    Atom.to_string(facility_type) |> String.replace("_", " ")
  end

  def friendly_facility_type(facility_type) do
    facility_type
  end
end
