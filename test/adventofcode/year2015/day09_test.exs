defmodule Adventofcode.Year2015.Day09Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day09
  doctest Day09

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
