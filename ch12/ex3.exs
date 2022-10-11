defmodule Check do
  def ok!(value) do
    case value do
      {:ok, data} -> data
      {:error, error} -> raise "#{error}"
      _ -> raise value
    end
  end
end