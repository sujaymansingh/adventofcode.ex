defmodule Adventofcode.Year2015.Day02 do
  @moduledoc """
  https://adventofcode.com/2015/day/2
  """

  def calculate_area(width, length, height) do
    [x, y, z] =
      [width, length, height]
      |> Enum.sort()

    2 * x * y + 2 * y * z + 2 * z * x + x * y
  end

  @doc """
    ## Examples

      iex> Adventofcode.Year2015.Day02.parse_line("2x3x4")
      {2, 3, 4}
  """
  def parse_line(line) do
    [w, l, h] =
      line
      |> String.trim()
      |> String.split("x")
      |> Enum.map(&Adventofcode.Parse.parse_int/1)

    {w, l, h}
  end

  def calculate_length(width, length, height) do
    [x, y, z] =
      [width, length, height]
      |> Enum.sort()

    2 * x + 2 * y + x * y * z
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day02

    def initial_acc(), do: 0

    def preprocess_line(line), do: Day02.parse_line(line)

    def combine({width, length, height}, acc) do
      Day02.calculate_area(width, length, height) + acc
    end

    def extract_result(acc), do: acc
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day02

    def initial_acc(), do: 0

    def preprocess_line(line), do: Day02.parse_line(line)

    def combine({width, length, height}, acc) do
      Day02.calculate_length(width, length, height) + acc
    end

    def extract_result(acc), do: acc
  end
end
