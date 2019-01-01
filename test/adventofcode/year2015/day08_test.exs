defmodule Adventofcode.Year2015.Day08Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day08
  doctest Day08

  def strings() do
    """
    ""
    "abc"
    "aaa\\"aaa"
    "\\x27"
    """
    |> String.split("\n", trim: true)
  end

  test "simple decoding" do
    decoded_strings = strings() |> Enum.map(&Day08.decode/1)
    assert decoded_strings === ["", "abc", "aaa\"aaa", "'"]

    lengths = decoded_strings |> Enum.map(&String.length/1)
    assert lengths == [0, 3, 7, 1]
  end

  test "part1" do
    result = Adventofcode.LineSolver.solve(strings(), Day08.Part1)
    assert result == 12
  end

  test "simple encoding" do
    encoded_strings = strings() |> Enum.map(&Day08.encode/1)

    lengths = encoded_strings |> Enum.map(&String.length/1)
    assert lengths == [6, 9, 16, 11]
  end

  test "part2" do
    result = Adventofcode.LineSolver.solve(strings(), Day08.Part2)
    assert result == 19
  end
end
