defmodule Adventofcode.Year2015.Day14Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day14
  doctest Adventofcode.Year2015.Day14

  test "simple distance calculations" do
    comet = {14, 10, 10 + 127}
    dancer = {16, 11, 11 + 162}

    assert Day14.distance_travelled(comet, 1) == 14
    assert Day14.distance_travelled(dancer, 1) == 16

    assert Day14.distance_travelled(comet, 10) == 140
    assert Day14.distance_travelled(dancer, 10) == 160

    assert Day14.distance_travelled(comet, 11) == 140
    assert Day14.distance_travelled(dancer, 11) == 176

    assert Day14.distance_travelled(comet, 1000) == 1120
    assert Day14.distance_travelled(dancer, 1000) == 1056

    assert Day14.distance_travelled(comet, 2503) == 2660
    assert Day14.distance_travelled(dancer, 2503) == 2640
  end

  test "ranking items" do
    items = [{"comet", {14, 10, 10 + 127}}, {"dancer", {16, 11, 11 + 162}}]

    assert Day14.rank_items(items, 1) == [{16, ["dancer"]}, {14, ["comet"]}]
    assert Day14.rank_items(items, 10) == [{160, ["dancer"]}, {140, ["comet"]}]
    assert Day14.rank_items(items, 1000) == [{1120, ["comet"]}, {1056, ["dancer"]}]
  end

  test "scoring leaders across time" do
    items = [{"comet", {14, 10, 10 + 127}}, {"dancer", {16, 11, 11 + 162}}]

    assert Day14.scores_across_times(items, 1000) == [{"dancer", 689}, {"comet", 312}]
  end

  test "part 1" do
    lines =
      """
      Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
      Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
      """
      |> String.split("\n", trim: true)

    assert Adventofcode.LineSolver.solve(lines, Day14.Part1) == 2660
  end
end
