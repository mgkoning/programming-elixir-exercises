defmodule Flatten do
  def flatten(xs), do: do_flatten(xs, [])
  defp do_flatten([], acc), do: Enum.reverse(acc)
  defp do_flatten([head = [_ | _] | xs], acc), do: do_flatten(head ++ xs, acc)
  defp do_flatten([x | xs], acc), do: do_flatten(xs, [x | acc])
end
