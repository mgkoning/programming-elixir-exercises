defmodule Chop do
  def guess(actual, range) do
    guess = halfway(range)
    IO.puts("Is it #{guess}?")
    check(actual, range, guess)
  end

  defp halfway(low..high), do: low + div(high - low, 2)

  defp check(actual, _, guess) when guess == actual, do: guess
  defp check(actual, _low..high, guess) when guess < actual, do: guess(actual, guess..high) 
  defp check(actual, low.._high, guess) when actual < guess, do: guess(actual, low..guess)
end
