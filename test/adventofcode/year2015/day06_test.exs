defmodule Adventofcode.Year2015.Day06Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day06
  alias Adventofcode.Year2015.Day06.Part1
  alias Adventofcode.Year2015.Day06.Part2

  test "using a basic grid" do
    initial = Day06.Grid.new(%Day06.BinaryGrid{}, 3, 3)
    assert Day06.Grid.total_brightness(initial) == 0

    intermediate = Day06.Grid.apply_instruction_to_rect(initial, :turn_on, {0, 1}, {2, 1})
    # the middle row is on
    assert Day06.Grid.total_brightness(intermediate) == 3

    final = Day06.Grid.apply_instruction_to_rect(intermediate, :toggle, {0, 0}, {2, 2})
    # 9 - 3
    assert Day06.Grid.total_brightness(final) == 6
  end

  @tag intensive: true, y2015: true, d06: true
  test "Part1 - following instructions" do
    assert Adventofcode.LineSolver.solve(["turn on 0,0 through 999,999"], Part1) == 1_000_000
    assert Adventofcode.LineSolver.solve(["toggle 0,0 through 999,0"], Part1) == 1000

    assert Adventofcode.LineSolver.solve(
             ["turn on 0,0 through 999,999", "turn off 499,499 through 500,500"],
             Part1
           ) == 999_996
  end

  @tag intensive: true, y2015: true, d06: true
  test "Part2 - following instructions" do
    assert Adventofcode.LineSolver.solve(["turn on 0,0 through 0,0"], Part2) == 1
    assert Adventofcode.LineSolver.solve(["toggle 0,0 through 999,999"], Part2) == 2_000_000
  end
end
