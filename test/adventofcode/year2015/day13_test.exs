defmodule Adventofcode.Year2015.Day13Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day13

  test "part1" do
    lines =
      """
      Alice would gain 54 happiness units by sitting next to Bob.
      Alice would lose 79 happiness units by sitting next to Carol.
      Alice would lose 2 happiness units by sitting next to David.
      Bob would gain 83 happiness units by sitting next to Alice.
      Bob would lose 7 happiness units by sitting next to Carol.
      Bob would lose 63 happiness units by sitting next to David.
      Carol would lose 62 happiness units by sitting next to Alice.
      Carol would gain 60 happiness units by sitting next to Bob.
      Carol would gain 55 happiness units by sitting next to David.
      David would gain 46 happiness units by sitting next to Alice.
      David would lose 7 happiness units by sitting next to Bob.
      David would gain 41 happiness units by sitting next to Carol.
      """
      |> String.split("\n", trim: true)

    assert Adventofcode.LineSolver.solve(lines, Day13.Part1) == 330
  end

  test "parsing" do
    assert Day13.parse("David would lose 7 happiness units by sitting next to Bob.") ==
             {{"David", "Bob"}, -7}

    assert Day13.parse("David would gain 41 happiness units by sitting next to Carol.") ==
             {{"David", "Carol"}, 41}
  end
end
