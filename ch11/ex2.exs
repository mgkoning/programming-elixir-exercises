defmodule CharList do
  def anagram?(one, other) do
    case {one -- other, other -- one} do
      {[], []} -> true
      _ -> false
    end
  end
end
