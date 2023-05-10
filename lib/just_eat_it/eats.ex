defmodule JustEatIt.Eats do
  @moduledoc """
  The Eats context.
  """

  import Ecto.Query, warn: false
  alias JustEatIt.Repo

  alias JustEatIt.Eats.{FoodFacility, FoodRandomizer}

  @doc """
  Returns the list of food_facilities.

  ## Examples

      iex> list_food_facilities()
      [%FoodFacility{}, ...]

  """
  def list_food_facilities do
    Repo.all(FoodFacility)
  end

  @doc """
  Returns a random list of food facilities, given an optional count and optional seed value.

  Seed values can be an integer or string. If no seed value is provided or a nill value is passed, the results will be random each time.

  ## Examples

      iex> random_food_facilities(3, 333)
      [%FoodFacility{}, ...]

      iex> random_food_facilities(2, "taco-time")
      [%FoodFacility{}, ...]

      iex> random_food_facilities(5)
      [%FoodFacility{}, ...]

  """
  def random_food_facilities(count \\ 5, seed \\ nil) do
    # This is inefficient, but works across any database and in-memory
    # For postgres, it would be better to use the random facilities and and take advantage of
    # a where clause that checks a range of numeric ids
    # or use sampling
    food_facilities = Repo.all(FoodFacility)
    FoodRandomizer.random(food_facilities, count, seed)
  end

  def next_random_food_facilities(count \\ 5) do
    # This is inefficient, but works across any database and in-memory
    # For postgres, it would be better to use the random facilities and and take advantage of
    # a where clause that checks a range of numeric ids
    # or use sampling
    food_facilities = Repo.all(FoodFacility)
    FoodRandomizer.take_next(food_facilities, count)
  end

  @doc """
  Gets a single food_facility.

  Raises `Ecto.NoResultsError` if the Food facility does not exist.

  ## Examples

      iex> get_food_facility!(123)
      %FoodFacility{}

      iex> get_food_facility!(456)
      ** (Ecto.NoResultsError)

  """
  def get_food_facility!(id), do: Repo.get!(FoodFacility, id)

  @doc """
  Creates a food_facility.

  ## Examples

      iex> create_food_facility(%{field: value})
      {:ok, %FoodFacility{}}

      iex> create_food_facility(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_food_facility(attrs \\ %{}) do
    %FoodFacility{}
    |> FoodFacility.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a food_facility.

  ## Examples

      iex> update_food_facility(food_facility, %{field: new_value})
      {:ok, %FoodFacility{}}

      iex> update_food_facility(food_facility, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_food_facility(%FoodFacility{} = food_facility, attrs) do
    food_facility
    |> FoodFacility.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food_facility.

  ## Examples

      iex> delete_food_facility(food_facility)
      {:ok, %FoodFacility{}}

      iex> delete_food_facility(food_facility)
      {:error, %Ecto.Changeset{}}

  """
  def delete_food_facility(%FoodFacility{} = food_facility) do
    Repo.delete(food_facility)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_facility changes.

  ## Examples

      iex> change_food_facility(food_facility)
      %Ecto.Changeset{data: %FoodFacility{}}

  """
  def change_food_facility(%FoodFacility{} = food_facility, attrs \\ %{}) do
    FoodFacility.changeset(food_facility, attrs)
  end
end
