defmodule Adventofcode.Year2015.Day14 do
  alias Adventofcode.Parse

  @doc """
  Parse the line that describes the motion

    ## Examples

    iex> line = "Rudolph can fly 22 km/s for 8 seconds, but then must rest for 165 seconds."
    iex> Adventofcode.Year2015.Day14.parse(line)
    {"Rudolph", {22, 8, 173}}
  """
  def parse([
        name,
        "can",
        "fly",
        speed,
        "km/s",
        "for",
        travel_time,
        "seconds,",
        "but",
        "then",
        "must",
        "rest",
        "for",
        rest_time,
        "seconds."
      ]) do
    speed_int = Parse.parse_int(speed)
    travel_time_int = Parse.parse_int(travel_time)
    rest_time_int = Parse.parse_int(rest_time)
    {name, {speed_int, travel_time_int, rest_time_int + travel_time_int}}
  end

  def parse(s), do: s |> String.split(" ", trim: true) |> parse()

  def distance_travelled({speed, travel_time, total_block_time}, time) do
    distance_travelled({speed, travel_time, total_block_time}, time, 0)
  end

  def distance_travelled(_, time, acc)
      when time <= 0,
      do: acc

  def distance_travelled({speed, travel_time, total_block_time}, time, acc) do
    actual_travel_time = Enum.min([travel_time, time])

    distance_travelled_in_block = speed * actual_travel_time

    distance_travelled(
      {speed, travel_time, total_block_time},
      time - total_block_time,
      acc + distance_travelled_in_block
    )
  end

  def rank_items(items, time) do
    # map[key].append(value)
    append_to = fn map, key, value ->
      {_, new_map} =
        Map.get_and_update(
          map,
          key,
          fn
            nil -> {nil, [value]}
            existing_values -> {existing_values, [value | existing_values]}
          end
        )

      new_map
    end

    items
    |> Enum.reduce(
      %{},
      fn {name, motion}, distances ->
        distance = distance_travelled(motion, time)
        append_to.(distances, distance, name)
      end
    )
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.reverse()
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day14

    @impl true
    def initial_acc(), do: []

    @impl true
    def preprocess_line(line), do: Day14.parse(line)

    @impl true
    def combine(new_item, items), do: [new_item | items]

    @impl true
    def extract_result(items) do
      [{distance, _names} | _] = Day14.rank_items(items, 2503)
      distance
    end
  end

  def scores_across_times(items, max_time) do
    initial_scores =
      items
      |> Enum.map(fn {name, _} -> {name, 0} end)
      |> Map.new()

    increment_each = fn scores, leaders ->
      Enum.reduce(
        leaders,
        scores,
        fn leader, acc ->
          {_, new_acc} = Map.get_and_update(acc, leader, &{&1, &1 + 1})
          new_acc
        end
      )
    end

    Enum.reduce(
      1..max_time,
      initial_scores,
      fn i, scores ->
        [{_distance, leaders} | _] = rank_items(items, i)
        increment_each.(scores, leaders)
      end
    )
    |> Enum.map(& &1)
    |> Enum.sort(fn {_, s1}, {_, s2} -> s1 < s2 end)
    |> Enum.reverse()
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day14

    @impl true
    def initial_acc(), do: []

    @impl true
    def preprocess_line(line), do: Day14.parse(line)

    @impl true
    def combine(new_item, items), do: [new_item | items]

    @impl true
    def extract_result(items) do
      [{_leader, score} | _] = Day14.scores_across_times(items, 2503)
      score
    end
  end
end
