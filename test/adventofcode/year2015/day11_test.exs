defmodule Adventofcode.Year2015.Day11Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day11
  doctest Day11

  test "incrementing alpha-strings" do
    assert Day11.increment("xx") == "xy"
    assert Day11.increment("xy") == "xz"
    assert Day11.increment("xz") == "ya"
    assert Day11.increment("ya") == "yb"

    assert Day11.increment("zz") == "aaa"
    assert Day11.increment("abcdefgz") == "abcdefha"
  end

  test "password validity" do
    assert Day11.valid?("hijklmmn") == false
    assert Day11.valid?("abbceffg") == false

    assert Day11.valid?("abcdffaa") == true
  end

  @tag intensive: true
  test "part1" do
    assert Adventofcode.LineSolver.solve(["abcdefgh"], Day11.Part1) == "abcdffaa"
    assert Adventofcode.LineSolver.solve(["ghijklmn"], Day11.Part1) == "ghjaabcc"
  end
end
