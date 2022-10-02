defmodule Binary do
  def center(list) do
    max_size = Enum.map(list, &(String.length &1)) |> Enum.max
    Enum.map(list, &(pad_word(&1, max_size)))
      |> Enum.each(&IO.puts/1)
  end
  
  defp pad_word(word, width) do
    to_pad = width - String.length word
    l = div(to_pad, 2)
    r = to_pad - l
    String.pad_leading(word, width - r) |> String.pad_trailing(width)
  end
end
