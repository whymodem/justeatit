defmodule JustEatIt.Eats.FoodRandomizer do
  @moduledoc """
  Handles randomly selecting food items using the Erlang `:rand` module. See `https://www.erlang.org/doc/man/rand.html`.

  Random numbers are generated using the `exsss` algorithm and are Pseudo random.
  It should be noted that this is not intended to be cryptographically strong.

  If stronger results are required, consider something that uses a fast,
  but decently strong hash algorithm like xxHash to be combined with a proper PRNG.

  One option is to use PCG http://www.pcg-random.org/. We don't here because we don't want any NIFs to affect stability,
  and we only need basic randomness provided by the Xorshift methods in Erlang.
  """

  @seed_algorithm :exsss

  @doc """
  Seeds random number generation using the exsss algorithm and integers in the process dictionary and returns the state.
  """
  def seed() do
    :rand.seed(@seed_algorithm)
  end

  def seed(seed) when is_integer(seed) do
    do_seed(seed)
  end

  def seed({s1, s2, s3} = seed) when is_integer(s1) and is_integer(s2) and is_integer(s3) do
    do_seed(seed)
  end

  def seed([seed]) do
    do_seed(seed)
  end

  def seed(seed) when is_binary(seed) do
    seed_value(seed) |> seed
  end

  def seed(nil) do
    seed()
  end

  defp do_seed(seed) do
    :rand.seed(@seed_algorithm, seed)
  end

  @doc """
  Generates a suitable seed value for use with the `FoodRandomizer`.

  If an integer is passed, it is already a good seed and used as is, otherwise the term is hashed and an integer is returned.
  """
  def seed_value(term) when is_integer(term) do
    term
  end

  def seed_value(term) do
    :erlang.phash2(term)
  end

  @doc """
  Returns count number of random items from a list of items using the given seed, if any.
  """
  def random(items, count \\ 1, seed \\ nil) do
    seed(seed)
    Enum.take_random(items, count)
  end

  @doc """
  Takes the next items specified by count without resetting a seed.
  """
  def take_next(items, count \\ 1) do
    Enum.take_random(items, count)
  end

  @doc """
  Gets the seed algorithm used by this randomizer.
  """
  def seed_algorithm() do
    @seed_algorithm
  end

end
