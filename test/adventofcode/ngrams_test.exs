defmodule Adventofcode.NgramsTest do
  use ExUnit.Case, async: true
  alias Adventofcode.Ngrams

  test "generating ngrams" do
    items = [1, 2, 3, 4]

    bigrams = Ngrams.generate(items, 2)
    assert bigrams == [[1, 2], [2, 3], [3, 4]]

    trigrams = Ngrams.generate(items, 3)
    assert trigrams == [[1, 2, 3], [2, 3, 4]]
  end
end
