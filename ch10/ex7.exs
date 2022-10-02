defmodule Primes do
  def span(from, to), do: for n <- from..to, do: n 

  def isPrime(p) do
    Enum.all?(3..div(p,2)//1, &(Integer.mod(p, &1) != 0))
  end

  def primes(n) do
    [2 | (for p <- 3..n//2, isPrime(p), do: p)]
  end 
end
