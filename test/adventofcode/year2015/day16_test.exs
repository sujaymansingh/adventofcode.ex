defmodule Adventofcode.Year2015.Day16Test do
  use ExUnit.Case, async: true
  alias Adventofcode.Year2015.Day16
  doctest Adventofcode.Year2015.Day16

  test "matching a dict against another" do
    spec = %{
      "children" => 3,
      "cats" => 7,
      "samoyeds" => 2,
      "pomeranians" => 3,
      "akitas" => 0,
      "vizslas" => 0,
      "goldfish" => 5,
      "trees" => 3,
      "cars" => 2,
      "perfumes" => 1
    }

    dict_1 = %{
      "children" => 1,
      "cats" => 7,
      "perfumes" => 1
    }

    dict_2 = %{
      "children" => 3,
      "cats" => 7,
      "perfumes" => 1
    }

    assert Day16.matches(spec, dict_1) == false
    assert Day16.matches(spec, dict_2) == true

    dict_3 = %{
      "children" => 3,
      "cats" => 8,
      "cars" => 2
    }

    dict_4 = %{
      "children" => 3,
      "cats" => 6,
      "cars" => 2
    }

    assert Day16.matches_complex(spec, dict_3) == true
    assert Day16.matches_complex(spec, dict_4) == false
  end
end
