defmodule Adventofcode.Year2015.Day09 do
  alias Adventofcode.Permutations

  @doc """
  Calculate the cost of the given route, given a map of distances

    ## Examples

      iex> costs = %{{:a, :b} => 1, {:b, :c} => 10, {:c, :a} => 100}
      iex> Adventofcode.Year2015.Day09.cost_of_route([:c, :b, :a], costs)
      11
      iex> Adventofcode.Year2015.Day09.cost_of_route([:c, :a, :b], costs)
      101
  """
  def cost_of_route(points, costs), do: cost_of_route(points, costs, 0)

  def cost_of_route([x, y], costs, acc) do
    acc + cost_of_edge(x, y, costs)
  end

  def cost_of_route([h1, h2 | t], costs, acc) do
    cost_of_route(
      [h2 | t],
      costs,
      acc + cost_of_edge(h1, h2, costs)
    )
  end

  def cost_of_edge(x, y, costs) do
    Enum.find_value(
      [{x, y}, {y, x}],
      fn pair -> Map.get(costs, pair) end
    )
  end

  def add_both_points({x, y}, acc) do
    acc |> MapSet.put(x) |> MapSet.put(y)
  end

  def cost_of_all_routes(costs) do
    Map.keys(costs)
    |> Enum.reduce(MapSet.new(), &add_both_points/2)
    |> Enum.to_list()
    |> Permutations.generate()
    |> Enum.map(&cost_of_route(&1, costs))
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day09

    @impl true
    def initial_acc(), do: %{}

    @impl true
    def preprocess_line(line), do: parse(line)

    defp parse(line) do
      [a, "to", b, "=", distance_str] = String.split(line, " ", trim: true)
      {{a, b}, Adventofcode.Parse.parse_int(distance_str)}
    end

    @impl true
    def combine({path, cost}, acc), do: Map.put(acc, path, cost)

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
    def preprocess_line(line), do: parse(line)

    defp parse(line) do
      [a, "to", b, "=", distance_str] = String.split(line, " ", trim: true)
      {{a, b}, Adventofcode.Parse.parse_int(distance_str)}
    end

    @impl true
    def combine({path, cost}, acc), do: Map.put(acc, path, cost)

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
