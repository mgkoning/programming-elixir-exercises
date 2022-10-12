defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can he -h or --help, which returns :help.

  Otherwise it is a github user name, prject name and (optionally)
  the number of entries to format.

  Return a tuple of `{user, project, count}` or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean],
                             aliases:  [ h:    :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    { user, project, String.to_integer(count) }
  end
  def args_to_internal_representation([user, project]) do
    { user, project, @default_count }
  end
  def args_to_internal_representation(_), do: :help

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({ user, project, count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> Enum.map(&issue_map_to_tuple/1)
    |> format_table()
    |> Enum.each(&IO.puts/1)
  end

  defp decode_response({:ok, body}), do: body
  defp decode_response({:error, error}) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 -> i2["created_at"] < i1["created_at"] end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def format_table(issues) do
    headers = {"#", "created_at", "title"}
    widths = issues
    |> Enum.map(&triple_to_sizes/1)
    |> Enum.reduce(triple_to_sizes(headers), &triple_max_by_elem/2)
    [ headers |> format_line(widths),
      underline(widths)
      | issues |> Enum.map(&format_line(&1, widths))]
  end

  defp triple_to_sizes({a, b, c}), do: { String.length(a), String.length(b), String.length(c) }

  defp triple_max_by_elem({a, b, c}, {d, e, f}), do: { max(a, d), max(b, e), max(c, f) }

  defp underline(widths) do
    widths
    |> Tuple.to_list()
    |> Enum.map(&String.duplicate("-", &1))
    |> Enum.join("-+-")
  end

  defp format_line({a, b, c}, {width_a, width_b, width_c}) do
    "#{center(a, width_a)} | #{String.pad_trailing(b, width_b)} | #{String.pad_trailing(c, width_c)}"
  end

  defp center(value, width) do
    value 
    |> String.pad_leading(width - div(width - String.length(value), 2))
    |> String.pad_trailing(width)
  end

  defp issue_map_to_tuple(issue_map) do
    {"#{issue_map["number"]}", issue_map["created_at"], issue_map["title"]}
  end
end