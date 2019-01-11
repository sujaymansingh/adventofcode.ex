defmodule Adventofcode.Year2015.Day16 do
  alias Adventofcode.Parse

  def matches(spec, dict) do
    Enum.all?(
      Map.keys(dict),
      fn key ->
        value = Map.get(dict, key)
        value != nil and value == Map.get(spec, key)
      end
    )
  end

  def matches_complex(spec, dict) do
    complex_keys = ["cats", "trees", "pomeranians", "goldfish"]

    simplify = fn map ->
      map
      |> Enum.filter(fn {k, _} -> k not in complex_keys end)
      |> Map.new()
    end

    simple_spec = simplify.(spec)
    simple_dict = simplify.(dict)

    matches(simple_spec, simple_dict) and greater_than_if_present("cats", spec, dict) and
      greater_than_if_present("trees", spec, dict) and
      less_than_if_present("pomeranians", spec, dict) and
      less_than_if_present("goldfish", spec, dict)
  end

  def greater_than_if_present(key, spec, dict) do
    cond do
      Map.has_key?(spec, key) and Map.has_key?(dict, key) ->
        dict[key] > spec[key]

      true ->
        true
    end
  end

  def less_than_if_present(key, spec, dict) do
    cond do
      Map.has_key?(spec, key) and Map.has_key?(dict, key) ->
        dict[key] < spec[key]

      true ->
        true
    end
  end

  @doc """
  Parse a line into a pair {number, attributes}

    ## Examples

    iex> Adventofcode.Year2015.Day16.parse("Sue 1: children: 1, cars: 8, vizslas: 7")
    {1, %{"children" => 1, "cars" => 8, "vizslas" => 7}}
  """
  def parse(line) do
    pattern = ~r/^Sue (?<num>[0-9]*): (?<attrs>.*)$/
    %{"num" => num_str, "attrs" => attrs_str} = Regex.named_captures(pattern, line)

    num = Parse.parse_int(num_str)

    attrs =
      attrs_str
      |> String.split(", ", trim: true)
      |> Enum.map(fn s -> String.split(s, ": ", trim: true) end)
      |> Enum.map(fn [name, value] -> {name, Parse.parse_int(value)} end)
      |> Map.new()

    {num, attrs}
  end

  def get_spec() do
    %{
      "children" => 3,
      "cats" => 7,
      "samoyeds" => 2,
      "pomeranians" => 3,
      "akitas" => 0,
      "vizslas" => 0,
      "goldfish" => 5,
      "trees" => 3,
      "cars" => 2,
      "perfumes" => 1
    }
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day16

    @impl true
    def initial_acc(), do: nil

    @impl true
    def preprocess_line(line), do: Day16.parse(line)

    @impl true
    def combine({num, profile}, acc) do
      spec = Day16.get_spec()
      if Day16.matches(spec, profile), do: num, else: acc
    end

    @impl true
    def extract_result(num), do: num
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day16

    @impl true
    def initial_acc(), do: nil

    @impl true
    def preprocess_line(line), do: Day16.parse(line)

    @impl true
    def combine({num, profile}, acc) do
      spec = Day16.get_spec()
      if Day16.matches_complex(spec, profile), do: num, else: acc
    end

    @impl true
    def extract_result(num), do: num
  end
end
