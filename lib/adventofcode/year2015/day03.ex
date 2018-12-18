defmodule Adventofcode.Year2015.Day03 do
  @moduledoc """
  https://adventofcode.com/2015/day/3
  """

  @doc """
  Process the instruction and move from the given point.

    ## Examples
    
      iex> Adventofcode.Year2015.Day03.handle_instruction(">", {1, 2})
      {2, 2}
      iex> Adventofcode.Year2015.Day03.handle_instruction("<", {1, 2})
      {0, 2}
      iex> Adventofcode.Year2015.Day03.handle_instruction("^", {1, 2})
      {1, 3}
      iex> Adventofcode.Year2015.Day03.handle_instruction("v", {1, 2})
      {1, 1}
  """
  def handle_instruction(">", {x, y}), do: {x + 1, y}
  def handle_instruction("<", {x, y}), do: {x - 1, y}
  def handle_instruction("^", {x, y}), do: {x, y + 1}
  def handle_instruction("v", {x, y}), do: {x, y - 1}
  def handle_instruction("V", {x, y}), do: handle_instruction("v", {x, y})

  @doc """
  Split a list into two by alternating items.

    ## Examples
    
      iex> Adventofcode.Year2015.Day03.split_alternatively([1, 2, 3, 4, 5, 6])
      {[1, 3, 5], [2, 4, 6]}

      iex> Adventofcode.Year2015.Day03.split_alternatively([1, 2, 3, 4, 5])
      {[1, 3, 5], [2, 4]}
  """
  def split_alternatively([], acc1, acc2), do: {Enum.reverse(acc1), Enum.reverse(acc2)}

  def split_alternatively([h1, h2 | t], acc1, acc2) do
    split_alternatively(t, [h1 | acc1], [h2 | acc2])
  end

  def split_alternatively([h1], acc1, acc2) do
    split_alternatively([], [h1 | acc1], acc2)
  end

  def split_alternatively(items), do: split_alternatively(items, [], [])

  def follow_instructions(instructions, acc) do
    List.foldl(instructions, acc, fn instruction, {position, visited_positions} ->
      new_position = handle_instruction(instruction, position)
      new_visited_positions = MapSet.put(visited_positions, new_position)
      {new_position, new_visited_positions}
    end)
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day03

    def initial_acc() do
      initial_position = {0, 0}
      {initial_position, MapSet.new([initial_position])}
    end

    def preprocess_line(line), do: String.split(line, "", trim: true)

    def combine(instructions, acc), do: Day03.follow_instructions(instructions, acc)

    def extract_result({_, visited_positions}), do: MapSet.size(visited_positions)
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day03

    def initial_acc() do
      santa = {0, 0}
      robosanta = {0, 0}
      {santa, robosanta, MapSet.new([santa, robosanta])}
    end

    def preprocess_line(line) do
      line |> String.split("", trim: true) |> Day03.split_alternatively()
    end

    def combine(
          {santa_instructions, robosanta_instructions},
          {santa_position, robosanta_position, visited_positions}
        ) do
      {new_santa_position, temp_visited_positions} =
        Day03.follow_instructions(santa_instructions, {santa_position, visited_positions})

      {new_robosanta_position, new_visited_positions} =
        Day03.follow_instructions(
          robosanta_instructions,
          {robosanta_position, temp_visited_positions}
        )

      {new_santa_position, new_robosanta_position, new_visited_positions}
    end

    def extract_result({_, _, visited_positions}), do: MapSet.size(visited_positions)
  end
end
