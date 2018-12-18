defmodule Adventofcode.Year2015.Day04Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day04

  @tag intensive: true
  test "calculating hashes starting with 5 zeros" do
    assert Day04.find_number("abcdef", 5) == 609_043
    assert Day04.find_number("pqrstuv", 5) == 1_048_970
  end
end
