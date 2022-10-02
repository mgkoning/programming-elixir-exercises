defmodule Binary do
  def capitalize_sentences(value) do
    String.split(value, ". ")
      |> Enum.map(&String.capitalize(&1))
      |> Enum.join(". ")
  end
end

