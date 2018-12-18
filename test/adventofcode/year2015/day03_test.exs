defmodule Adventofcode.Year2015.Day03Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day03.Part1
  alias Adventofcode.Year2015.Day03.Part2
  doctest Adventofcode.Year2015.Day03

  test "Part1" do
    assert Adventofcode.LineSolver.solve([">"], Part1) == 2
    assert Adventofcode.LineSolver.solve(["^>v<"], Part1) == 4
    assert Adventofcode.LineSolver.solve(["^v^v^v^v^v"], Part1) == 2
  end

  test "Part2" do
    assert Adventofcode.LineSolver.solve(["^v"], Part2) == 3
    assert Adventofcode.LineSolver.solve(["^>v<"], Part2) == 3
    assert Adventofcode.LineSolver.solve(["^v^v^v^v^v"], Part2) == 11
  end
end
