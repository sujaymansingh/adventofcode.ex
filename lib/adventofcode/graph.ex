defmodule Adventofcode.Graph do
  @moduledoc """
  Utilities for dealing with paths
  """
  alias Adventofcode.Permutations

  @doc """
  Calculate the cost of a path, given a list of directed edges.

    ## Examples

      iex> edges = %{{:a, :b} => 1, {:b, :c} => 10, {:a, :c} => 2, {:c, :b} => 3}
      iex> Adventofcode.Graph.cost_of_path([:a, :b, :c], edges)
      11
      iex> Adventofcode.Graph.cost_of_path([:a, :c, :b], edges)
      5
      iex> Adventofcode.Graph.cost_of_path([], edges)
      0
  """
  def cost_of_path([], _), do: 0
  def cost_of_path(path, edges), do: cost_of_path(path, edges, 0)

  defp cost_of_path([_], _, acc), do: acc

  defp cost_of_path([h1, h2 | t], edges, acc) do
    h1_h2_cost = Map.get(edges, {h1, h2})

    if h1_h2_cost == nil do
      IO.puts("Cost of #{h1},#{h2} is nil in #{edges |> inspect}")
    end

    cost_of_path([h2 | t], edges, acc + h1_h2_cost)
  end

  @doc """
  Return a set of all the nodes, given a dict of edges.

    ## Examples

      iex> edges = %{{:a, :b} => 1, {:b, :c} => 10, {:a, :c} => 2, {:c, :b} => 3}
      iex> Adventofcode.Graph.nodes(edges)
      MapSet.new([:a, :b, :c])
  """
  def nodes(edges) do
    Enum.reduce(
      Map.keys(edges),
      MapSet.new(),
      fn {x, y}, acc -> acc |> MapSet.put(x) |> MapSet.put(y) end
    )
  end

  def cycles(x) when not is_list(x), do: cycles(Enum.to_list(x))

  def cycles([h | t]) do
    for permutation <- Permutations.generate(t) do
      [h | permutation] ++ [h]
    end
  end
end
