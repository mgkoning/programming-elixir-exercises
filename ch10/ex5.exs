defmodule MyEnum do
  def all?([], _pred), do: true
  def all?([x | xs], pred), do: pred.(x) and all?(xs, pred)

  def each([], _f), do: :ok
  def each([x | xs], f) do 
    f.(x)
    each(xs, f)
  end

  def filter([], _pred), do: []
  def filter([x | xs], pred) do
    if pred.(x), do: [x | filter(xs, pred)], else: filter(xs, pred)
  end

  def split(list, at), do: do_split(list, at, []) 
  defp do_split(rest, at, prefix) when at == 0 or rest == [], do: { Enum.reverse(prefix), rest }
  defp do_split([x | xs], at, prefix), do: do_split(xs, at-1, [x | prefix]) 

  def take(list, n), do: do_take(list, n, [])
  defp do_take(rest, n, taken) when n == 0 or rest == [], do: Enum.reverse(taken)
  defp do_take([x|xs], n, taken), do: do_take(xs, n-1, [x|taken]) 
end
