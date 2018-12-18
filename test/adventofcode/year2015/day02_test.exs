defmodule Adventofcode.Year2015.Day02Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day02

  doctest Adventofcode.Year2015.Day02

  test "calculating wrapping paper area" do
    assert Day02.calculate_area(2, 3, 4) == 58
    assert Day02.calculate_area(1, 1, 10) == 43
  end

  test "calculating ribbon length" do
    assert Day02.calculate_length(2, 3, 4) == 34
    assert Day02.calculate_length(1, 1, 10) == 14
  end
end
