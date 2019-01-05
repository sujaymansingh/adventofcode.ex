defmodule Adventofcode.PermutationsTest do
  use ExUnit.Case, async: true
  alias Adventofcode.Permutations

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

    assert MapSet.new(Permutations.generate(items)) == MapSet.new(expected)
  end
end
