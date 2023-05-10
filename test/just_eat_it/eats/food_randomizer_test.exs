defmodule JustEatIt.Eats.FoodRandomizerTest do
  use ExUnit.Case, async: false
  alias JustEatIt.Eats.FoodRandomizer

  test "Randomizes consistently using a binary seed value" do
    values = ["red", "blue", "green", "orange", "magenta", "violet", "cyan"]

    assert FoodRandomizer.random(values, 1, "colors") == ["cyan"]
    assert FoodRandomizer.random(values, 2, "colors") == ["cyan", "orange"]
    assert FoodRandomizer.random(values, 3, "colors") == ["cyan", "orange", "magenta"]
    assert FoodRandomizer.random(values, 4, "colors") == ["cyan", "orange", "magenta", "green"]
    assert FoodRandomizer.random(values, 5, "colors") == ["cyan", "orange", "magenta", "green", "blue"]
    assert FoodRandomizer.random(values, 6, "colors") == ["cyan", "orange", "magenta", "green", "blue", "red"]
    assert FoodRandomizer.random(values, 7, "colors") == ["cyan", "orange", "magenta", "green", "blue", "red", "violet"]
    assert FoodRandomizer.random(values, 8, "colors") == ["cyan", "orange", "magenta", "green", "blue", "red", "violet"]
    assert FoodRandomizer.random(values, 9, "colors") == ["cyan", "orange", "magenta", "green", "blue", "red", "violet"]

    assert FoodRandomizer.random(values, 7, "deadbeef") == [
             "violet",
             "blue",
             "orange",
             "magenta",
             "green",
             "red",
             "cyan"
           ]

    assert FoodRandomizer.random(values, 7, "colors") == ["cyan", "orange", "magenta", "green", "blue", "red", "violet"]
  end

  test "Randomizes consistently using an integer seed value" do
    values = ["red", "blue", "green", "orange", "magenta", "violet", "cyan"]

    assert FoodRandomizer.random(values, 1, 28) == ["blue"]
    assert FoodRandomizer.random(values, 2, 28) == ["blue", "red"]
    assert FoodRandomizer.random(values, 3, 28) == ["blue", "red", "orange"]
    assert FoodRandomizer.random(values, 4, 28) == ["blue", "red", "orange", "magenta"]
    assert FoodRandomizer.random(values, 5, 28) == ["blue", "red", "orange", "magenta", "violet"]
    assert FoodRandomizer.random(values, 6, 28) == ["blue", "red", "orange", "magenta", "violet", "green"]
    assert FoodRandomizer.random(values, 7, 28) == ["blue", "red", "orange", "magenta", "violet", "green", "cyan"]
    assert FoodRandomizer.random(values, 8, 28) == ["blue", "red", "orange", "magenta", "violet", "green", "cyan"]
    assert FoodRandomizer.random(values, 9, 28) == ["blue", "red", "orange", "magenta", "violet", "green", "cyan"]
    assert FoodRandomizer.random(values, 7, 33) == ["violet", "magenta", "green", "cyan", "blue", "orange", "red"]
    assert FoodRandomizer.random(values, 7, 28) == ["blue", "red", "orange", "magenta", "violet", "green", "cyan"]
  end

  test "taking the next seed value is sequentially predictable given a seed" do
    values = ["red", "blue", "green", "orange", "magenta", "violet", "cyan"]
    FoodRandomizer.seed("colors")

    assert FoodRandomizer.take_next(values, 2) == ["cyan", "orange"]
    assert FoodRandomizer.take_next(values, 2) == ["violet", "red"]

    assert FoodRandomizer.take_next(values, 3) == ["orange", "green", "magenta"]
    assert FoodRandomizer.take_next(values, 4) == ["green", "cyan", "violet", "blue"]
    assert FoodRandomizer.take_next(values, 5) == ["green", "red", "cyan", "blue", "magenta"]
    assert FoodRandomizer.take_next(values, 6) == ["blue", "orange", "magenta", "violet", "green", "red"]
    assert FoodRandomizer.take_next(values, 7) == ["cyan", "blue", "magenta", "red", "violet", "orange", "green"]
    assert FoodRandomizer.take_next(values, 8) == ["violet", "cyan", "blue", "magenta", "green", "red", "orange"]
    assert FoodRandomizer.take_next(values, 9) == ["orange", "green", "red", "cyan", "violet", "blue", "magenta"]

    FoodRandomizer.seed("colors")
    assert FoodRandomizer.take_next(values, 1) == ["cyan"]
    assert FoodRandomizer.take_next(values, 2) == ["violet", "red"]
    assert FoodRandomizer.take_next(values, 3) == ["orange", "green", "magenta"]
    assert FoodRandomizer.take_next(values, 4) == ["green", "cyan", "violet", "blue"]
    assert FoodRandomizer.take_next(values, 5) == ["green", "red", "cyan", "blue", "magenta"]
    assert FoodRandomizer.take_next(values, 6) == ["blue", "orange", "magenta", "violet", "green", "red"]
    assert FoodRandomizer.take_next(values, 7) == ["cyan", "blue", "magenta", "red", "violet", "orange", "green"]
    assert FoodRandomizer.take_next(values, 8) == ["violet", "cyan", "blue", "magenta", "green", "red", "orange"]
    assert FoodRandomizer.take_next(values, 9) == ["orange", "green", "red", "cyan", "violet", "blue", "magenta"]
  end

  test "integers are used as seeds untouched" do
    assert FoodRandomizer.seed_value(123) == 123
    refute FoodRandomizer.seed_value("123") == 123
    refute FoodRandomizer.seed_value("123") == "123"
  end

  test "terms produce consistent integer seed values" do
    assert FoodRandomizer.seed_value("abc") == 98_228_475
    assert FoodRandomizer.seed_value(:abc) == 26499
    assert FoodRandomizer.seed_value("לבזבז זמן") == 85_660_989
  end

  test "exsss is the current seed algorithm" do
    assert FoodRandomizer.seed_algorithm() == :exsss
  end
end
