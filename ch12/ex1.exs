defmodule FizzBuzzCase do
  def up_to(n), do: 1..n |> Enum.map(&fizz_word/1)
  defp fizz_word(n) do
    case { rem(n, 3), rem(n, 5) } do
      {0, 0} -> "FizzBuzz"
      {0, _} -> "Fizz"
      {_, 0} -> "Buzz"
      _      -> n
    end
  end
end