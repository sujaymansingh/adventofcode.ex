defmodule Adventofcode.Year2015.Day11 do
  alias Adventofcode.Ngrams

  def next_valid_password(initial) do
    next = increment(initial)

    if valid?(next) do
      next
    else
      next_valid_password(next)
    end
  end

  def valid?(password) do
    charlist = String.to_charlist(password)

    with true <- has_straight?(charlist),
         true <- not contains_bad_chars?(charlist),
         true <- has_two_distinct_non_overlapping_pairs?(charlist) do
      true
    else
      false -> false
    end
  end

  def increment(alpha_string) do
    alpha_string
    |> String.to_charlist()
    |> Enum.reverse()
    |> increment_reversed_charlist()
    |> Enum.reverse()
    |> to_string()
  end

  defp increment_reversed_charlist([122]), do: [97, 97]

  defp increment_reversed_charlist([122 | t]) do
    [97 | increment_reversed_charlist(t)]
  end

  defp increment_reversed_charlist([h | t]), do: [h + 1 | t]

  def has_straight?(charlist) do
    charlist
    |> Ngrams.generate(3)
    |> Enum.any?(&is_straight?/1)
  end

  @doc """
  Return true if the the list contains an 'increasing straight' of 3 numbers

    ## Examples

    iex> Adventofcode.Year2015.Day11.is_straight?('xyz')
    true
    iex> Adventofcode.Year2015.Day11.is_straight?('abd')
    false
  """
  def is_straight?([a, b, c]), do: c == b + 1 and b == a + 1

  @doc """
  Return true if any of the forbidden characters are present in the given charlist.

  By default, the forbidden characters are i, o and l

    ## Examples
    
    iex> Adventofcode.Year2015.Day11.contains_bad_chars?('hijklmmn')
    true
    iex> Adventofcode.Year2015.Day11.contains_bad_chars?('abbceffg')
    false
  """
  def contains_bad_chars?(charlist, forbidden \\ 'iol') do
    Enum.any?(forbidden, &(&1 in charlist))
  end

  def has_two_distinct_non_overlapping_pairs?(charlist) do
    num =
      charlist
      |> non_overlapping_pairs()
      |> MapSet.new()
      |> MapSet.size()

    num >= 2
  end

  @doc """
  Return all the non-overlapping pairs of identical characters in a charlist

    # Examples

      iex> Adventofcode.Year2015.Day11.non_overlapping_pairs('xxx')
      ['xx']
      iex> Adventofcode.Year2015.Day11.non_overlapping_pairs('ghjaabcc')
      ['aa', 'cc']
      iex> Adventofcode.Year2015.Day11.non_overlapping_pairs('abbcegjk')
      ['bb']
  """
  def non_overlapping_pairs(charlist) do
    nop(Ngrams.generate(charlist, 2), [])
  end

  defp nop([], acc), do: Enum.reverse(acc)

  defp nop([[x, x], [x, x] | t], acc) do
    # The middle x will overlap!
    nop([[x, x] | t], acc)
  end

  defp nop([[x, x] | t], acc) do
    nop(t, [[x, x] | acc])
  end

  defp nop([[_, _] | t], acc) do
    nop(t, acc)
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day11

    @impl true
    def initial_acc(), do: ""

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(line, _) do
      Day11.next_valid_password(line)
    end

    @impl true
    def extract_result(acc), do: acc
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day11

    @impl true
    def initial_acc(), do: ""

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(line, _) do
      line |> Day11.next_valid_password() |> Day11.next_valid_password()
    end

    @impl true
    def extract_result(acc), do: acc
  end
end
