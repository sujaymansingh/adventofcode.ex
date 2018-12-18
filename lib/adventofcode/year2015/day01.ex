defmodule Adventofcode.Year2015.Day01 do
  @moduledoc """
  https://adventofcode.com/2015/day/1
  """

  def to_movement(40), do: 1
  def to_movement(41), do: -1

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day01

    @impl true
    def initial_acc(), do: 0

    @impl true
    def preprocess_line(line) do
      line |> String.to_charlist() |> Enum.map(&Day01.to_movement/1)
    end

    @impl true
    def combine(movements, acc) do
      acc + Enum.sum(movements)
    end

    @impl true
    def extract_result(result), do: result
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day01

    @impl true
    def initial_acc() do
      current_floor = 0
      num_steps = 0
      {current_floor, num_steps}
    end

    @impl true
    def preprocess_line(line) do
      line |> String.to_charlist() |> Enum.map(&Day01.to_movement/1)
    end

    @impl true
    def combine(_movements, {-1, num_steps}) do
      # This is a little bit of a hack as we can't 'return early'.
      # If we've reached -1 then don't even bother processing movements.
      {-1, num_steps}
    end

    @impl true
    def combine(movements, {current_floor, num_steps}) do
      process_until_basement(movements, {current_floor, num_steps})
    end

    defp process_until_basement([], {current_floor, num_steps}), do: {current_floor, num_steps}

    defp process_until_basement(_, {-1, num_steps}), do: {-1, num_steps}

    defp process_until_basement([h | t], {current_floor, num_steps}) do
      new_floor = h + current_floor
      process_until_basement(t, {new_floor, num_steps + 1})
    end

    @impl true
    def extract_result({_current_floor, num_steps}) do
      num_steps
    end
  end
end
