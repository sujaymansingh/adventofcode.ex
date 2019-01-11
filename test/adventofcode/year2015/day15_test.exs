defmodule Adventofcode.Year2015.Day15Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day15
  doctest Day15
  doctest Day15.Item

  test "combining ingredients" do
    butterscotch = %Day15.Item{capacity: -1, durability: -2, flavor: 6, texture: 3, calories: 8}
    cinnamon = %Day15.Item{capacity: 2, durability: 3, flavor: -2, texture: -1, calories: 3}

    expected = %Day15.Item{capacity: 68, durability: 80, flavor: 152, texture: 76, calories: 520}
    assert Day15.Item.combine([{butterscotch, 44}, {cinnamon, 56}]) == expected
  end

  test "calculating score" do
    item_1 = %Day15.Item{capacity: 68, durability: 80, flavor: 152, texture: 76, calories: 520}
    assert Day15.Item.score(item_1) == 62_842_880

    item_2 = %Day15.Item{capacity: -68, durability: 80, flavor: 152, texture: 76, calories: 520}
    assert Day15.Item.score(item_2) == 0
  end

  test "get the best combination" do
    butterscotch = %Day15.Item{capacity: -1, durability: -2, flavor: 6, texture: 3, calories: 8}
    cinnamon = %Day15.Item{capacity: 2, durability: 3, flavor: -2, texture: -1, calories: 3}

    result = Day15.get_best_combination([butterscotch, cinnamon], 100)
    assert result == 62_842_880
  end

  test "parsing" do
    {name, item} =
      Day15.parse("Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5")

    assert name == "Frosting"
    assert item == %Day15.Item{capacity: 4, durability: -2, flavor: 0, texture: 0, calories: 5}
  end
end
