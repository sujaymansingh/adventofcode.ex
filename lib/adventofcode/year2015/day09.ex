defmodule Adventofcode.Year2015.Day09 do
  alias Adventofcode.Graph
  alias Adventofcode.Permutations

  def cost_of_all_routes(costs) do
    Graph.nodes(costs)
    |> Permutations.generate()
    |> Enum.map(&Graph.cost_of_path(&1, costs))
  end

  def combine({{x, y}, cost}, acc) do
    acc
    |> Map.put({x, y}, cost)
    |> Map.put({y, x}, cost)
  end

  def parse(line) do
    [a, "to", b, "=", distance_str] = String.split(line, " ", trim: true)
    {{a, b}, Adventofcode.Parse.parse_int(distance_str)}
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day09

    @impl true
    def initial_acc(), do: %{}
    @impl true
    def combine(edge, acc), do: Day09.combine(edge, acc)

    @impl true
    def preprocess_line(line), do: Day09.parse(line)

    @impl true
    def extract_result(costs) do
      [shortest_path | _] =
        costs
        |> Day09.cost_of_all_routes()
        |> Enum.sort(&(&1 < &2))

      shortest_path
    end
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day09

    @impl true
    def initial_acc(), do: %{}

    @impl true
    def preprocess_line(line), do: Day09.parse(line)

    @impl true
    def combine(edge, acc), do: Day09.combine(edge, acc)

    @impl true
    def extract_result(costs) do
      [longest_path | _] =
        costs
        |> Day09.cost_of_all_routes()
        |> Enum.sort(&(&1 > &2))

      longest_path
    end
  end
end
