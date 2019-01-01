defmodule Adventofcode.Year2015.Day09Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day09
  doctest Day09

  test "permutations" do
    items = ["a", "b", "c"]

    expected = [
      ["a", "b", "c"],
      ["a", "c", "b"],
      ["b", "a", "c"],
      ["b", "c", "a"],
      ["c", "a", "b"],
      ["c", "b", "a"]
    ]

    assert MapSet.new(Day09.permutations(items)) == MapSet.new(expected)
  end

  test "Part1" do
    lines =
      """
      London to Dublin = 464
      London to Belfast = 518
      Dublin to Belfast = 141
      """
      |> String.split("\n", trim: true)

    assert Adventofcode.LineSolver.solve(lines, Day09.Part1) == 605
  end
end
