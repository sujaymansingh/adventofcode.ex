defmodule Adventofcode.Year2015.Day05Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day05

  doctest Day05

  test "Part1 - nice strings" do
    assert Day05.nice?("ugknbfddgicrmopn") == true
    assert Day05.nice?("aaa") == true
    assert Day05.nice?("jchzalrnumimnmhp") == false
    assert Day05.nice?("haegwjzuvuyypxyu") == false
    assert Day05.nice?("dvszwmarrgswjxmb") == false
  end

  test "Part2 - nice strings" do
    assert Day05.actually_nice?("qjhvhtzxzqqjkmpb") == true
    assert Day05.actually_nice?("xxyxx") == true
    assert Day05.actually_nice?("uurcxstgmygtbstg") == false
    assert Day05.actually_nice?("ieodomkazucvgmuy") == false
  end
end
