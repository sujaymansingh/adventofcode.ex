defmodule Adventofcode.Year2015.Day13 do
  alias Adventofcode.Graph

  def cost_of_all_cycles(costs) do
    Graph.nodes(costs)
    |> Graph.cycles()
    |> Enum.map(&Graph.cost_of_path(&1, costs))
  end

  def parse([a, "would", "lose", x, _, _, _, _, _, _, b]) do
    {{a, b}, 0 - Adventofcode.Parse.parse_int(x)}
  end

  def parse([a, "would", "gain", x, _, _, _, _, _, _, b]) do
    {{a, b}, Adventofcode.Parse.parse_int(x)}
  end

  def parse(line) do
    line
    |> String.trim(".")
    |> String.split(" ", trim: true)
    |> parse()
  end

  def combine({{x, y}, cost}, acc) do
    existing_xy = Map.get(acc, {x, y}, 0)
    existing_yx = Map.get(acc, {y, x}, 0)

    # Remember, the cost of putting x next to y is cost(x, y) + cost(y, x)
    # However, they appear out of order.
    # Thus we check for existing_yx in case the opposite cost to us was added, earlier,
    # and we update yx in case we are the latter.
    acc
    |> Map.put({x, y}, existing_xy + cost)
    |> Map.put({y, x}, existing_yx + cost)
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day13

    @impl true
    def initial_acc(), do: %{}

    @impl true
    def preprocess_line(line), do: Day13.parse(line)

    @impl true
    def combine(edge, acc), do: Day13.combine(edge, acc)

    @impl true
    def extract_result(costs) do
      [longest_path | _] =
        costs
        |> Day13.cost_of_all_cycles()
        |> Enum.sort(&(&1 > &2))

      longest_path
    end
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day13

    @impl true
    def initial_acc(), do: %{}

    @impl true
    def preprocess_line(line), do: Day13.parse(line)

    @impl true
    def combine(edge, acc), do: Day13.combine(edge, acc)

    @impl true
    def extract_result(costs) do
      costs_with_self =
        Enum.reduce(
          Graph.nodes(costs),
          costs,
          fn node, acc ->
            acc
            |> Map.put({:self, node}, 0)
            |> Map.put({node, :self}, 0)
          end
        )

      [longest_path | _] =
        costs_with_self
        |> Day13.cost_of_all_cycles()
        |> Enum.sort(&(&1 > &2))

      longest_path
    end
  end
end
