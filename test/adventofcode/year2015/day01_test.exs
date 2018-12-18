defmodule Adventofcode.Year2015.Day01Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day01
  alias Adventofcode.LineSolver

  test "Part1" do
    for floor_0 <- ["(())", "()()"] do
      assert LineSolver.solve([floor_0], Day01.Part1) == 0
    end

    for floor_3 <- ["(((", "(()(()(", "))((((("] do
      assert LineSolver.solve([floor_3], Day01.Part1) == 3
    end

    for basement <- ["())", "))("] do
      assert LineSolver.solve([basement], Day01.Part1) == -1
    end

    for floor_minus_3 <- [")))", ")())())"] do
      assert LineSolver.solve([floor_minus_3], Day01.Part1) == -3
    end
  end

  test "Part2" do
    assert LineSolver.solve([")"], Day01.Part2) == 1
    assert LineSolver.solve(["()())"], Day01.Part2) == 5
  end
end
