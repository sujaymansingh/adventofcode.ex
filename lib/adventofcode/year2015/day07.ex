defmodule Adventofcode.Year2015.Day07 do
  use Bitwise

  @doc """
  'Clamp' an integer value betwen 0 and 65535 (16-bit unsigned int)

    ## Examples
      iex> Adventofcode.Year2015.Day07.bound_integer(50)
      50
      iex> Adventofcode.Year2015.Day07.bound_integer(-1)
      65535
      iex> Adventofcode.Year2015.Day07.bound_integer(65537)
      1
  """
  def bound_integer(x) when x >= 0 and x < 65536, do: x
  def bound_integer(x) when x < 0, do: bound_integer(x + 65536)
  def bound_integer(x) when x >= 65536, do: bound_integer(x - 65536)

  def evaluate(gate, inputs), do: _evaluate(gate, inputs) |> bound_integer()

  def _evaluate(:and, [x, y]), do: x &&& y
  def _evaluate(:or, [x, y]), do: x ||| y
  def _evaluate(:lshift, [x, y]), do: x <<< y
  def _evaluate(:rshift, [x, y]), do: x >>> y
  def _evaluate(:not, [x]), do: ~~~x
  def _evaluate(:eval, [x]), do: x

  defmodule Circuit do
    alias Adventofcode.Year2015.Day07
    defstruct data: %{}

    def new() do
      %Circuit{}
    end

    def add(circuit, output, expression) when is_integer(expression) do
      circuit
      |> put_data(:expression, output, expression)
      |> set_calculated_value(output, expression)
    end

    def add(circuit, output, expression) do
      circuit
      |> put_data(:expression, output, expression)
      |> attempt_calculation_of_output(output)
    end

    def get_value(circuit, output) do
      new_circuit = attempt_calculation_of_output(circuit, output)
      {:ok, new_circuit.data[{:calculated, output}]}
    end

    def get_expression(circuit, output), do: circuit.data[{:expression, output}]

    def get_dependants(circuit, output) do
      Map.get(circuit.data, {:dependants, output}, MapSet.new())
    end

    defp put_data(circuit, data_type, output, value) do
      key = {data_type, output}
      new_data = circuit.data |> Map.put(key, value)
      %{circuit | data: new_data}
    end

    defp mark_dependancy(circuit, a, :depends_on, b) do
      new_dependants = get_dependants(circuit, b) |> MapSet.put(a)
      put_data(circuit, :dependants, b, new_dependants)
    end

    defp clear_dependants(circuit, output) do
      put_data(circuit, :dependants, output, MapSet.new())
    end

    defp attempt_calculation_of_dependants(circuit, output) do
      Enum.reduce(
        get_dependants(circuit, output),
        circuit,
        fn dependant, initial_circuit ->
          attempt_calculation_of_output(initial_circuit, dependant)
        end
      )
    end

    defp get_calculated_value(_, value) when is_integer(value), do: value

    defp get_calculated_value(circuit, output) do
      value = circuit.data[{:calculated, output}]
      if is_integer(value), do: value, else: nil
    end

    defp set_calculated_value(circuit, output, exact_value) do
      circuit
      |> put_data(:calculated, output, exact_value)
      |> attempt_calculation_of_dependants(output)
      |> clear_dependants(output)
    end

    defp attempt_calculation_of_output(circuit, output) do
      expression = circuit.data[{:expression, output}]

      case expression do
        nil ->
          circuit

        {gate, inputs} ->
          calculated_values = Enum.map(inputs, &get_calculated_value(circuit, &1))

          updated_circuit =
            if Enum.all?(calculated_values, &is_integer/1) do
              # yay! all of these are integers so we can just compute the value.
              value = Day07.evaluate(gate, calculated_values)

              # Now that we have a value of `output`, we should (re)attempt all the things
              # that depended on it as they might now be possible.
              circuit
              |> set_calculated_value(output, value)
              |> attempt_calculation_of_dependants(output)
            else
              # oh no, not all are calculated
              mark_dependancy_if_needed = fn
                {_, value}, circuit when is_integer(value) -> circuit
                {input, _value}, circuit -> mark_dependancy(circuit, output, :depends_on, input)
              end

              Enum.reduce(
                Enum.zip(inputs, calculated_values),
                circuit,
                mark_dependancy_if_needed
              )
            end

          # If we have any calculated values, we should use them...
          new_inputs =
            inputs
            |> Enum.zip(calculated_values)
            |> Enum.map(fn {input, calculated_value} ->
              if calculated_value != nil, do: calculated_value, else: input
            end)

          updated_circuit
          |> put_data(:expression, output, {gate, new_inputs})

        _ ->
          circuit
      end
    end

    def parse(line) do
      line
      |> String.split(" ", trim: true)
      |> _parse()
    end

    def _parse([input, "->", output]) do
      symbol_or_literal = symbol_or_literal(input)

      if is_integer(symbol_or_literal) do
        {output, symbol_or_literal}
      else
        {output, {:eval, [symbol_or_literal]}}
      end
    end

    def _parse([input_1, binary_func, input_2, "->", output]) do
      {output,
       {
         to_symbol(binary_func),
         [symbol_or_literal(input_1), symbol_or_literal(input_2)]
       }}
    end

    def _parse([unary_func, input, "->", output]) do
      {output, {to_symbol(unary_func), [symbol_or_literal(input)]}}
    end

    defp symbol_or_literal(x) do
      case Integer.parse(x) do
        {value, ""} -> Day07.bound_integer(value)
        :error -> x
      end
    end

    defp to_symbol("AND"), do: :and
    defp to_symbol("OR"), do: :or
    defp to_symbol("LSHIFT"), do: :lshift
    defp to_symbol("RSHIFT"), do: :rshift
    defp to_symbol("NOT"), do: :not
  end

  defmodule Part1 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day07.Circuit

    def initial_acc(), do: Circuit.new()

    def preprocess_line(line), do: Circuit.parse(line)

    def combine({output, expression}, circuit), do: Circuit.add(circuit, output, expression)

    def extract_result(circuit) do
      {:ok, value} = Circuit.get_value(circuit, "a")
      value
    end
  end

  defmodule Part2 do
    @behaviour Adventofcode.LineSolver
    alias Adventofcode.Year2015.Day07.Circuit

    def initial_acc(), do: Circuit.new()

    def preprocess_line(line), do: Circuit.parse(line)

    def combine({output, expression}, circuit) do
      if output == "b" do
        # We need to ignore the values for b as we will override it with the calculated
        # value of 'a' (as per requirements)
        circuit
      else
        Circuit.add(circuit, output, expression)
      end
    end

    def extract_result(circuit) do
      {:ok, value} =
        circuit
        |> Circuit.add("b", 3176)
        |> Circuit.get_value("a")

      value
    end
  end
end
