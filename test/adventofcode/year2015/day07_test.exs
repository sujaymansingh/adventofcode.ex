defmodule Adventofcode.Year2015.Day07Test do
  use ExUnit.Case, async: true

  alias Adventofcode.Year2015.Day07
  alias Adventofcode.Year2015.Day07.Circuit

  doctest Day07

  test "internal workings of circuit" do
    c1 = Circuit.new()

    c2 = Circuit.add(c1, "e", {:lshift, ["d", 2]})
    assert Circuit.get_expression(c2, "e") == {:lshift, ["d", 2]}
    assert Circuit.get_dependants(c2, "d") == MapSet.new(["e"])

    c3 = Circuit.add(c2, "d", {:and, ["x", "y"]})
    assert Circuit.get_expression(c3, "d") == {:and, ["x", "y"]}
    assert Circuit.get_dependants(c3, "x") == MapSet.new(["d"])
    assert Circuit.get_dependants(c3, "y") == MapSet.new(["d"])

    c4 = Circuit.add(c3, "x", 123)
    assert Circuit.get_expression(c4, "x") == 123
    assert Circuit.get_dependants(c4, "x") == MapSet.new()
    assert Circuit.get_expression(c4, "d") == {:and, [123, "y"]}

    c5 = Circuit.add(c4, "y", 456)
    assert Circuit.get_dependants(c5, "y") == MapSet.new()
    assert Circuit.get_expression(c5, "d") == {:and, [123, 456]}
    assert Circuit.get_value(c5, "d") == {:ok, 72}
    assert Circuit.get_value(c5, "e") == {:ok, 288}

    c6 = Circuit.add(c5, "f", {:eval, ["d"]})
    assert Circuit.get_value(c6, "f") == {:ok, 72}
  end

  test "parsing a line" do
    assert Circuit.parse("123 -> x") == {"x", 123}
    assert Circuit.parse("456 -> y") == {"y", 456}
    assert Circuit.parse("x AND y -> d") == {"d", {:and, ["x", "y"]}}
    assert Circuit.parse("x OR y -> e") == {"e", {:or, ["x", "y"]}}
    assert Circuit.parse("x LSHIFT 2 -> f") == {"f", {:lshift, ["x", 2]}}
    assert Circuit.parse("y RSHIFT 2 -> g") == {"g", {:rshift, ["y", 2]}}
    assert Circuit.parse("NOT x -> h") == {"h", {:not, ["x"]}}
    assert Circuit.parse("NOT y -> i") == {"i", {:not, ["y"]}}
  end

  test "passing in a circuit" do
    instructions =
      """
      123 -> x
      456 -> y
      x AND y -> d
      x OR y -> e
      x LSHIFT 2 -> f
      y RSHIFT 2 -> g
      NOT x -> h
      NOT y -> i
      """
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&Circuit.parse/1)

    combine = fn {output, expression}, circuit -> Circuit.add(circuit, output, expression) end

    final = Enum.reduce(instructions, Circuit.new(), combine)
    assert_expected(final)

    # reversed = Enum.reverse(instructions)
    # final_reversed = Enum.reduce(reversed, Circuit.new(), combine)
    # assert_expected(final_reversed)
  end

  def assert_expected(circuit) do
    assert Circuit.get_value(circuit, "d") == {:ok, 72}
    assert Circuit.get_value(circuit, "e") == {:ok, 507}
    assert Circuit.get_value(circuit, "f") == {:ok, 492}
    assert Circuit.get_value(circuit, "g") == {:ok, 114}
    assert Circuit.get_value(circuit, "h") == {:ok, 65412}
    assert Circuit.get_value(circuit, "i") == {:ok, 65079}
    assert Circuit.get_value(circuit, "x") == {:ok, 123}
    assert Circuit.get_value(circuit, "y") == {:ok, 456}
  end
end
