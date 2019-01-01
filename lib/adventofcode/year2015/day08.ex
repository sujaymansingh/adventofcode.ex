defmodule Adventofcode.Year2015.Day08 do
  def decode(string) do
    desired_length = String.length(string) - 2
    # TODO: we're stripping off the first and last chars, but we're not
    # explicitly checking that they are double-quotes... should we?
    string
    |> String.slice(1, desired_length)
    |> String.split("", trim: true)
    |> decode([])
  end

  defp decode([], acc) do
    acc |> Enum.reverse() |> Enum.join("")
  end

  defp decode(["\\", "\\" | t], acc) do
    decode(t, ["\\" | acc])
  end

  defp decode(["\\", "\"" | t], acc) do
    decode(t, ["\"" | acc])
  end

  defp decode(["\\", "x", a, b | t], acc) do
    {:ok, char} = (a <> b) |> Base.decode16(case: :mixed)
    decode(t, [char | acc])
  end

  defp decode([h | t], acc) do
    decode(t, [h | acc])
  end

  def encode(string) do
    chars =
      string
      |> String.split("", trim: true)
      |> encode([])

    "\"" <> chars <> "\""
  end

  defp encode([], acc) do
    acc |> Enum.reverse() |> Enum.join("")
  end

  defp encode(["\"" | t], acc) do
    encode(t, ["\"", "\\" | acc])
  end

  defp encode(["\\" | t], acc) do
    encode(t, ["\\", "\\" | acc])
  end

  defp encode([h | t], acc), do: encode(t, [h | acc])

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day08

    @impl true
    def initial_acc(), do: {0, 0}

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(encoded_string, {encoded_length, decoded_length}) do
      decoded_string = Day08.decode(encoded_string)

      {
        encoded_length + String.length(encoded_string),
        decoded_length + String.length(decoded_string)
      }
    end

    @impl true
    def extract_result({encoded, decoded}), do: encoded - decoded
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day08

    @impl true
    def initial_acc(), do: {0, 0}

    @impl true
    def preprocess_line(line), do: line

    @impl true
    def combine(decoded_string, {encoded_length, decoded_length}) do
      encoded_string = Day08.encode(decoded_string)

      {
        encoded_length + String.length(encoded_string),
        decoded_length + String.length(decoded_string)
      }
    end

    @impl true
    def extract_result({encoded, decoded}), do: encoded - decoded
  end
end
