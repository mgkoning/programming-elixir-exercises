defmodule CharList do
  def is_printable?(charlist) do
    Enum.all?(charlist, fn c -> c in ?\s..?~ end)
  end
end
