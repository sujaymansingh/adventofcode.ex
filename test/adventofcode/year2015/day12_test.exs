defmodule Adventofcode.Year2015.Day12Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day12

  test "extract numbers" do
    f = fn _ -> true end
    assert Day12.sum([1, 2, 3], f) == 6
    assert Day12.sum([[[3]]], f) == 3
    assert Day12.sum(%{"a" => 2, "b" => 4}, f) == 6
    assert Day12.sum(%{"a" => %{"b" => 4}, "c" => -1}, f) == 3

    assert Day12.sum([1, 2, 3], &(&1 != 2)) == 4
  end

  test "checking if something is red" do
    assert Day12.red?([1, 2, 3]) == false
    assert Day12.red?(%{"b" => 2, "c" => "red"}) == true
    assert Day12.red?([1, %{"b" => 2, "c" => "red"}, 3]) == false
    assert Day12.red?([1, "red", 5]) == false
  end
end
