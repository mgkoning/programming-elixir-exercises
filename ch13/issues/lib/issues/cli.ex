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
    properties = ["#", "created_at", "title"]
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> format_table(properties)
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

  def format_table(issues, properties) do
    rows = issues
    |> Enum.map(&extract_properties(&1, properties))
    column_sizes = [properties | rows]
    |> Enum.map(fn row -> Enum.map(row, &String.length/1) end)
    |> Enum.reduce(fn next, acc -> Enum.zip_with(acc, next, &max/2) end)

    [ properties |> format_row(column_sizes),
      underline(column_sizes)
      | rows |> Enum.map(&format_row(&1, column_sizes))
    ]
  end

  defp extract_properties(issue, properties) do
    Enum.map(properties, &"#{issue[prop_name(&1)]}")
  end

  defp prop_name("#"), do: "number"
  defp prop_name(n), do: n

  defp format_row(row, widths) do
    row 
    |> Enum.zip_with(widths, fn h, w -> String.pad_trailing(h, w) end)
    |> Enum.join(" | ")
  end

  defp underline(widths) do
    widths
    |> Enum.map(&String.duplicate("-", &1))
    |> Enum.join("-+-")
  end

end