defmodule Adventofcode.Year2015.Day12 do
  def sum(x, is_valid?) when is_integer(x) do
    if is_valid?.(x), do: x, else: 0
  end

  def sum(x, is_valid?) when is_list(x) do
    if is_valid?.(x), do: sum(x, is_valid?, 0), else: 0
  end

  def sum(x, is_valid?) when is_map(x) do
    if is_valid?.(x) do
      sum(Map.keys(x), is_valid?) + sum(Map.values(x), is_valid?)
    else
      0
    end
  end

  def sum(_, _), do: 0

  defp sum([h | t], is_valid?, acc) do
    sum_of_h = if is_valid?.(h), do: sum(h, is_valid?), else: 0
    sum(t, is_valid?, sum_of_h + acc)
  end

  defp sum([], _, acc), do: acc

  def red?(m) when is_map(m) do
    "red" in Map.values(m)
  end

  def red?(_), do: false

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day12

    @impl true
    def initial_acc(), do: 0

    @impl true
    def preprocess_line(line), do: Poison.decode!(line)

    @impl true
    def combine(object, acc) do
      total = object |> Day12.sum(fn _ -> true end)
      acc + total
    end

    @impl true
    def extract_result(acc), do: acc
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day12

    @impl true
    def initial_acc(), do: 0

    @impl true
    def preprocess_line(line), do: Poison.decode!(line)

    @impl true
    def combine(object, acc) do
      total = object |> Day12.sum(&(not Day12.red?(&1)))
      acc + total
    end

    @impl true
    def extract_result(acc), do: acc
  end
end
