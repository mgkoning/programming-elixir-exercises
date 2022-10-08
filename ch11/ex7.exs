defmodule ReadTaxes do
  ## from ch10, ex8
  def tax_rates, do: [ NC: 0.075, TX: 0.08 ]

  def calculateTax(orders, rates) do
    for o <- orders do
      total_amount = o[:net_amount] * (1.0 + Keyword.get(rates, o[:ship_to], 0.00))
      Keyword.put(o, :total_amount, total_amount)
    end
  end
  ##

  def read_sales(file_name) do
    { :ok, file } = File.open(file_name)
    IO.stream(file, :line)
      |> Enum.drop(1)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&parse_parts/1)
  end

  defp parse_parts([id, ship_to, net_amount]) do
    [ id: String.to_integer(id),
      ship_to: String.to_atom(String.slice(ship_to, 1..-1//1)),
      net_amount: String.to_float(net_amount) ]
  end
end

IO.inspect(
  ReadTaxes.read_sales("sales.txt")
    |> ReadTaxes.calculateTax(ReadTaxes.tax_rates()))
