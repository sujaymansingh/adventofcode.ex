defmodule Adventofcode.CLI do
  def main(raw_args) do
    {_parsed, varargs, _invalid} = OptionParser.parse(raw_args, switches: [verbose: :boolean])

    with {:ok, year, day, part} <- parse_varargs(varargs),
         {:ok, line_solver} <- get_line_solver(year, day, part),
         {:ok, input_stream} <- load_input_file(year, day) do
      result = Adventofcode.LineSolver.solve(input_stream, line_solver)
      IO.puts("#{inspect(result)}")
      :ok
    else
      {:error, msg} -> IO.puts("Error: #{msg}")
    end
  end

  defp parse_varargs([year_string, day_string, part_string]) do
    with {:ok, year} <- parseint(year_string),
         {:ok, day} <- parseint(day_string),
         {:ok, part} <- parseint(part_string) do
      {
        :ok,
        year |> Integer.to_string(),
        day |> Integer.to_string() |> String.pad_leading(2, "0"),
        part |> Integer.to_string()
      }
    else
      _ -> {:error, :bad_var_args}
    end
  end

  defp parse_varargs(_), do: {:error, :bad_var_args}

  defp get_line_solver(year, day, part) do
    module_base = "Elixir.Adventofcode.Year" <> year <> ".Day" <> day <> ".Part"
    # TODO: Don't use to_atom!!
    case part do
      "1" -> {:ok, (module_base <> "1") |> String.to_atom()}
      "2" -> {:ok, (module_base <> "2") |> String.to_atom()}
      _ -> {:error, :bad_module}
    end
  end

  defp load_input_file(year, day) do
    filename = "inputs/" <> year <> day <> ".txt"

    if File.exists?(filename) do
      {:ok, File.stream!(filename)}
    else
      {:error, :no_input_file}
    end
  end

  defp parseint(str) do
    with {num, ""} <- Integer.parse(str) do
      {:ok, num}
    else
      _ -> {:error, :not_an_int}
    end
  end
end
