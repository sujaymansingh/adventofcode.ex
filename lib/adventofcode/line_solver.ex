defmodule Adventofcode.LineSolver do
  @callback initial_acc() :: any
  @callback preprocess_line(String.t()) :: any
  @callback combine(any, any) :: any
  @callback extract_result(any) :: integer

  def solve(lines, line_solver) do
    initial_acc = line_solver.initial_acc()

    lines
    |> Stream.map(fn line ->
      line |> String.trim_trailing("\n") |> line_solver.preprocess_line()
    end)
    |> Enum.reduce(initial_acc, &line_solver.combine/2)
    |> line_solver.extract_result()
  end
end
