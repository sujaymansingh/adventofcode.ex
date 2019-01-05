defmodule Adventofcode.Permutations do
  def generate(x) when not is_list(x), do: generate(Enum.to_list(x))

  def generate([]) do
    [[]]
  end

  def generate(list) do
    for h <- list, t <- generate(list -- [h]), do: [h | t]
  end
end
