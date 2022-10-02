defmodule Recursion do
  def mapSum([], _), do: 0
  def mapSum([head | tail], func), do: func.(head) + mapSum(tail, func)

  def max([head]), do: head
  def max([head | tail]) do
    restMax = max(tail)
    if(head < restMax, do: restMax, else: head)
  end
  
  def caesar([], _n), do: []
  def caesar([head|list], n), do: [ addAndWrap(head, n) | caesar(list, n)]
  defp addAndWrap(x, n) do
    rotated = x + n
    if(rotated < 122, do: rotated, else: rotated - 26)
  end

  def span(from, to) when to <= from, do: []
  def span(from, to), do: [from | span(from+1, to)]
end
