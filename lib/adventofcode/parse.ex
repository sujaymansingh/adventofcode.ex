defmodule Adventofcode.Parse do
  def parse_int(s) do
    with {num, ""} <- Integer.parse(s) do
      num
    else
      _ -> {:error, s}
    end
  end
end
