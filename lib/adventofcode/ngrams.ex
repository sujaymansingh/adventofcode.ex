defmodule Adventofcode.Ngrams do
  @doc """
  Split an list into ngrams of the given length
  """
  def generate(items, size) do
    generate(items, size, [])
  end

  defp generate(items, size, acc) when length(items) < size do
    Enum.reverse(acc)
  end

  defp generate([h | t], size, acc) do
    {ngram, _} = Enum.split([h | t], size)
    generate(t, size, [ngram | acc])
  end
end
