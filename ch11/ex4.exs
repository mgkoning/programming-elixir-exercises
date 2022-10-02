defmodule CharList do
  def run_calc(expr), do: _lhs(expr, [])

  defp _lhs([l | ls], s) do
    cond do
       l in '01234567890' -> _lhs(ls, [l | s])
       l in ' ' -> _op(ls, Enum.reverse(s))
       true -> raise "unexpected: #{l}"
    end
  end

  defp _op([ o | rest ], lhs) do
    if o in '+-/*' do
      _rhs(rest, lhs, o, [])
    else
      raise "unexpected: #{o}"
    end
  end

  defp _rhs([r | rs], lhs, o, s) do
    cond do
      r in ' ' -> _rhs(rs, lhs, o, s)
      r in '0123456789' -> _rhs(rs, lhs, o, [r | s])
    end
  end

  defp _rhs([], lhs, o, s), do: _value(lhs, o, Enum.reverse(s))

  defp _value(lhs, o, rhs) do
    l = _number_digits(lhs, 0)
    r = _number_digits(rhs, 0)
    case o do
      ?- -> l - r
      ?+ -> l + r
      ?* -> l * r
      ?/ -> div(l, r)
    end
  end

  defp _number_digits([], value), do: value
  defp _number_digits([n|ns], value), do: _number_digits(ns, value * 10 + n - ?0)
end
