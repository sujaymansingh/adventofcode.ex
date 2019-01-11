defmodule Adventofcode.Collection do
  defmodule Counter do
    @moduledoc """
    Treat a map as a counter.

      ## Examples

      iex> alias Adventofcode.Collection.Counter
      iex> c1 = Counter.new()
      %{}
      iex> c2 = Counter.increment(c1, :a)
      %{:a => 1}
      iex> c3 = Counter.increment(c2, :a)
      %{:a => 2}
      iex> Counter.increment_many(c3, [:a, :b, :c])
      %{:a => 3, :b => 1, :c => 1}
    """

    def new(), do: %{}

    def increment(counter, key) do
      {_, new_counter} =
        Map.get_and_update(
          counter,
          key,
          fn
            nil -> {nil, 1}
            count -> {count, count + 1}
          end
        )

      new_counter
    end

    def increment_many(original_counter, keys) do
      Enum.reduce(
        keys,
        original_counter,
        fn key, counter ->
          increment(counter, key)
        end
      )
    end
  end
end
