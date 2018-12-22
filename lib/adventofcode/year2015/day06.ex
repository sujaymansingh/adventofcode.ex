defmodule Adventofcode.Year2015.Day06 do
  @moduledoc """
  https://adventofcode.com/2015/day/6
  """

  defprotocol GenericGrid do
    def initial_value(grid)
    def apply_instruction(grid, original_value, instruction)
  end

  defmodule BinaryGrid do
    defstruct point_values: Map.new()
  end

  defimpl GenericGrid, for: BinaryGrid do
    def initial_value(_grid), do: 0

    def apply_instruction(_, _, :turn_on), do: 1
    def apply_instruction(_, _, :turn_off), do: 0

    def apply_instruction(_, 1, :toggle), do: 0
    def apply_instruction(_, 0, :toggle), do: 1
  end

  defmodule NordicGrid do
    defstruct point_values: Map.new()
  end

  defimpl GenericGrid, for: NordicGrid do
    def initial_value(_grid), do: 0

    def apply_instruction(_, x, :turn_on), do: x + 1

    def apply_instruction(_, 0, :turn_off), do: 0
    def apply_instruction(_, x, :turn_off), do: x - 1

    def apply_instruction(_, x, :toggle), do: x + 2
  end

  defmodule Grid do
    def new(grid, width, height) do
      raw_points = for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y}
      base_value = GenericGrid.initial_value(grid)

      point_values =
        raw_points
        |> List.foldl(
          Map.new(),
          fn point, grid -> Map.put(grid, point, base_value) end
        )

      %{grid | point_values: point_values}
    end

    def get(grid, {x, y}), do: Map.get(grid.point_values, {x, y})

    def put(grid, {x, y}, value) do
      new_values = Map.put(grid.point_values, {x, y}, value)
      %{grid | point_values: new_values}
    end

    def total_brightness(grid) do
      grid.point_values
      |> Enum.map(fn {_, value} -> value end)
      |> Enum.sum()
    end

    @doc """
    Return a list of all the points contained (inclusive) within the range.

      ## Examples

        iex> Adventofcode.Year2015.Day06.Grid.expand({499, 499}, {500, 500})
        [{499, 499}, {500, 499}, {499, 500}, {500, 500}]
    """
    def expand({start_x, start_y}, {end_x, end_y}) when start_x <= end_x and start_y <= end_y do
      for y <- start_y..end_y, x <- start_x..end_x, do: {x, y}
    end

    def apply_instruction_to_rect(starting_grid, instruction, start_point, end_point) do
      Enum.reduce(
        expand(start_point, end_point),
        starting_grid,
        fn point, grid ->
          original_value = get(grid, point)
          new_value = GenericGrid.apply_instruction(grid, original_value, instruction)
          put(grid, point, new_value)
        end
      )
    end

    @doc """
    Parse a line into a set of instructions.

      ## Examples

        iex> Adventofcode.Year2015.Day06.Grid.parse_line("turn on 499,499 through 500,500")
        {:turn_on, {499, 499}, {500, 500}}
    """
    def parse_line(line) do
      [end_point_str, "through", start_point_str | rest] = String.split(line) |> Enum.reverse()

      start_point = parse_point(start_point_str)
      end_point = parse_point(end_point_str)

      instruction =
        case rest do
          ["off", "turn"] -> :turn_off
          ["on", "turn"] -> :turn_on
          ["toggle"] -> :toggle
        end

      {instruction, start_point, end_point}
    end

    defp parse_point(point_str) do
      [x, y] = point_str |> String.split(",") |> Enum.map(&Adventofcode.Parse.parse_int/1)
      {x, y}
    end
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day06.BinaryGrid
    alias Adventofcode.Year2015.Day06.Grid

    @impl true
    def initial_acc(), do: Grid.new(%BinaryGrid{}, 1000, 1000)

    @impl true
    def preprocess_line(line), do: Grid.parse_line(line)

    @impl true
    def combine({instruction, start_point, end_point}, grid) do
      Grid.apply_instruction_to_rect(grid, instruction, start_point, end_point)
    end

    @impl true
    def extract_result(grid), do: Grid.total_brightness(grid)
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day06.BinaryGrid
    alias Adventofcode.Year2015.Day06.Grid

    @impl true
    def initial_acc(), do: Grid.new(%NordicGrid{}, 1000, 1000)

    @impl true
    def preprocess_line(line), do: Grid.parse_line(line)

    @impl true
    def combine({instruction, start_point, end_point}, grid) do
      Grid.apply_instruction_to_rect(grid, instruction, start_point, end_point)
    end

    @impl true
    def extract_result(grid), do: Grid.total_brightness(grid)
  end
end
