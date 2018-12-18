defmodule Adventofcode.Year2015.Day05 do
  @moduledoc """
  https://adventofcode.com/2015/day/5
  """

  @doc """
  A string is 'nice' if
  - It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
  - It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
  - It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
  """
  def nice?(string) do
    chars = String.to_charlist(string)

    with true <- check_num_vowels(chars),
         true <- check_repeated_chars(ngrams(chars, 2)),
         true <- check_bad_substrings(string) do
      true
    else
      _ -> false
    end
  end

  defp check_num_vowels(chars) do
    vowels = MapSet.new('aeiou')
    num_vowels = chars |> Enum.filter(&MapSet.member?(vowels, &1)) |> length()
    num_vowels >= 3
  end

  defp check_repeated_chars(ngrams) do
    Enum.any?(ngrams, &the_same?/1)
  end

  defp the_same?([h, h]), do: true
  defp the_same?(_), do: false

  defp check_bad_substrings(string) do
    bad_substrings = ["ab", "cd", "pq", "xy"]
    not Enum.any?(bad_substrings, &String.contains?(string, &1))
  end

  @doc """
  A string is actually nice if
  - It contains a pair of any two letters that appears at least twice in the string without overlapping,
    like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
  - It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe),
    or even aaa.
  """
  def actually_nice?(string) do
    chars = String.to_charlist(string)

    with true <- has_non_overlapping_pair?(chars),
         true <- has_xyx?(chars) do
      true
    else
      _ -> false
    end
  end

  @doc """
  Return true if there exists a pair of any two letters that appears at least twice in the string without overlapping.

    # Examples

      iex> Adventofcode.Year2015.Day05.has_non_overlapping_pair?('xyxy')
      true
      iex> Adventofcode.Year2015.Day05.has_non_overlapping_pair?('aabcdefgaa')
      true
      iex> Adventofcode.Year2015.Day05.has_non_overlapping_pair?('aaa')
      false
      iex> Adventofcode.Year2015.Day05.has_non_overlapping_pair?('aaaa')
      true
  """
  def has_non_overlapping_pair?(chars) do
    has_nop?(ngrams(chars, 2), MapSet.new())
  end

  defp has_nop?([bigram, bigram | tail], seen_bigrams) do
    # This is an overlapping pair...
    has_nop?(tail, MapSet.put(seen_bigrams, bigram))
  end

  defp has_nop?([bigram | tail], seen_bigrams) do
    if MapSet.member?(seen_bigrams, bigram) do
      true
    else
      has_nop?(tail, MapSet.put(seen_bigrams, bigram))
    end
  end

  defp has_nop?([], _), do: false

  defp has_xyx?(chars) do
    chars |> ngrams(3) |> Enum.any?(&is_xyx?/1)
  end

  defp is_xyx?([x, _, x]), do: true
  defp is_xyx?(_), do: false

  @doc """
  Split an list into ngrams of the given length

    ## Examples
    
      iex> Adventofcode.Year2015.Day05.ngrams([1, 2, 3, 4], 2)
      [[1, 2], [2, 3], [3, 4]]
      iex> Adventofcode.Year2015.Day05.ngrams([1, 2, 3, 4], 3)
      [[1, 2, 3], [2, 3, 4]]
  """
  def ngrams(items, size) do
    ngrams(items, size, [])
  end

  def ngrams(items, size, acc) when length(items) < size do
    Enum.reverse(acc)
  end

  def ngrams([h | t], size, acc) do
    {ngram, _} = Enum.split([h | t], size)
    ngrams(t, size, [ngram | acc])
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day05

    @impl true
    def initial_acc(), do: 0

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(string, acc) do
      if Day05.nice?(string), do: acc + 1, else: acc
    end

    @impl true
    def extract_result(acc), do: acc
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day05

    @impl true
    def initial_acc(), do: 0

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(string, acc) do
      if Day05.actually_nice?(string), do: acc + 1, else: acc
    end

    @impl true
    def extract_result(acc), do: acc
  end
end
