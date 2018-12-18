defmodule Adventofcode.Year2015.Day04 do
  @moduledoc """
  https://adventofcode.com/2015/day/4
  """

  def find_number(secret_key, prefix_length) do
    prefix = String.duplicate("0", prefix_length)
    attempt(secret_key, prefix, 0)
  end

  defp attempt(secret_key, prefix, current_number) do
    full_key = secret_key <> Integer.to_string(current_number)
    hash = :crypto.hash(:md5, full_key) |> Base.encode16()

    if String.starts_with?(hash, prefix) do
      current_number
    else
      attempt(secret_key, prefix, current_number + 1)
    end
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day04

    def initial_acc(), do: []

    def preprocess_line(line), do: String.trim(line)

    def combine(secret_key, acc) do
      result = Day04.find_number(secret_key, 5)
      [result | acc]
    end

    def extract_result(acc) do
      [h | _] = Enum.reverse(acc)
      h
    end
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day04

    def initial_acc(), do: []

    def preprocess_line(line), do: String.trim(line)

    def combine(secret_key, acc) do
      result = Day04.find_number(secret_key, 6)
      [result | acc]
    end

    def extract_result(acc) do
      [h | _] = Enum.reverse(acc)
      h
    end
  end
end
