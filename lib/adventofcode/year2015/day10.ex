defmodule Adventofcode.Year2015.Day10 do
  @doc """
  Given a string, return the next 'look-and-say' sequence.

    ## Examples

    iex> Adventofcode.Year2015.Day10.next_sequence("1")
    "11"
    iex> Adventofcode.Year2015.Day10.next_sequence("11")
    "21"
    iex> Adventofcode.Year2015.Day10.next_sequence("21")
    "1211"
    iex> Adventofcode.Year2015.Day10.next_sequence("1211")
    "111221"
    iex> Adventofcode.Year2015.Day10.next_sequence("111221")
    "312211"
  """
  def next_sequence(sequence) do
    sequence
    |> String.split("", trim: true)
    |> group_characters([])
    |> Enum.map(fn {length, char} -> to_string(length) <> char end)
    |> Enum.join("")
  end

  defp group_characters([], acc) do
    acc |> Enum.reverse()
  end

  defp group_characters([h | t], [{c, h} | acc]) do
    group_characters(t, [{c + 1, h} | acc])
  end

  defp group_characters([h | t], acc) do
    group_characters(t, [{1, h} | acc])
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day10

    @impl true
    def initial_acc(), do: ""

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(line, _) do
      Enum.reduce(
        1..40,
        line,
        fn _, sequence -> Day10.next_sequence(sequence) end
      )
    end

    @impl true
    def extract_result(acc), do: String.length(acc)
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day10

    @impl true
    def initial_acc(), do: ""

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(line, _) do
      Enum.reduce(
        1..50,
        line,
        fn _, sequence -> Day10.next_sequence(sequence) end
      )
    end

    @impl true
    def extract_result(acc), do: String.length(acc)
  end
end
