defmodule Adventofcode.Year2015.Day15 do
  alias Adventofcode.Collection.Counter
  alias Adventofcode.Parse

  defmodule Item do
    defstruct capacity: 0, durability: 0, flavor: 0, texture: 0, calories: 0

    def score(item) do
      score_or_zero = fn x -> if x > 0, do: x, else: 0 end

      [item.capacity, item.durability, item.flavor, item.texture]
      |> Enum.map(score_or_zero)
      |> Enum.reduce(1, fn comp, acc -> comp * acc end)
    end

    def combine(items) do
      combine(items, %Item{})
    end

    defp combine([], acc), do: acc

    defp combine([{h, quantity} | t], acc) do
      new_acc = %Item{
        capacity: quantity * h.capacity + acc.capacity,
        durability: quantity * h.durability + acc.durability,
        flavor: quantity * h.flavor + acc.flavor,
        texture: quantity * h.texture + acc.texture,
        calories: quantity * h.calories + acc.calories
      }

      combine(t, new_acc)
    end
  end

  def parse(s) do
    [name, parts] = s |> String.split(": ")

    parse(name, parts |> String.replace(",", "") |> String.split(" ", trim: true))
  end

  defp parse(
         name,
         ["capacity", cp, "durability", d, "flavor", f, "texture", t, "calories", cl]
       ) do
    {name,
     %Item{
       capacity: Parse.parse_int(cp),
       durability: Parse.parse_int(d),
       flavor: Parse.parse_int(f),
       texture: Parse.parse_int(t),
       calories: Parse.parse_int(cl)
     }}
  end

  def combinations(items, 1), do: Enum.map(items, &[&1])

  def combinations([a, b], n) do
    Enum.map(
      0..n,
      fn i -> repeat(a, i) ++ repeat(b, n - i) end
    )
  end

  def combinations(items, n) do
    len = length(items)

    Enum.flat_map(
      0..(len - 1),
      fn i ->
        sub_slice = Enum.slice(items, i, len)
        [h | _] = sub_slice

        for sub_combination <- combinations(sub_slice, n - 1) do
          [h | sub_combination]
        end
      end
    )
  end

  @doc """
  Repeat the given item `len` times.

    ## Examples

    iex> Adventofcode.Year2015.Day15.repeat(:a, 4)
    [:a, :a, :a, :a]
  """
  def repeat(_, 0), do: []

  def repeat(item, len) do
    Enum.reduce(1..len, [], fn _, acc -> [item | acc] end)
  end

  def get_item_combinations(items, num_units) do
    items
    |> combinations(num_units)
    |> MapSet.new()
    |> Enum.map(&(Counter.new() |> Counter.increment_many(&1) |> Enum.to_list()))
    |> Enum.map(&Item.combine(&1))
  end

  def get_best_combination(items, num_units, filter_func \\ fn _ -> true end) do
    items
    |> get_item_combinations(num_units)
    |> Enum.filter(filter_func)
    |> Enum.map(&Item.score/1)
    |> Enum.max()
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day15

    @impl true
    def initial_acc(), do: []

    @impl true
    def preprocess_line(line) do
      {_name, item} = Day15.parse(line)
      item
    end

    @impl true
    def combine(line, acc), do: [line | acc]

    @impl true
    def extract_result(acc) do
      Day15.get_best_combination(acc, 100)
    end
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day15

    @impl true
    def initial_acc(), do: []

    @impl true
    def preprocess_line(line) do
      {_name, item} = Day15.parse(line)
      item
    end

    @impl true
    def combine(line, acc), do: [line | acc]

    @impl true
    def extract_result(acc) do
      Day15.get_best_combination(acc, 100, fn item -> item.calories == 500 end)
    end
  end
end
