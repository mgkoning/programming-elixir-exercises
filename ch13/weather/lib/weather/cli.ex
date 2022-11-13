defmodule Weather.CLI do
  require Logger
  import Weather.Fetch

  def main(argv) do
    parse_args(argv)
    |> process()
  end

  defp parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> convert_args()
  end

  defp convert_args([location]), do: { location }
  defp convert_args(_), do: :help

  defp process(:help) do
    IO.puts """
      usage: weather location
      """
    System.halt(0)
  end

  defp process({ location }) do
    Logger.info("Time to find stuff for #{location}")
    fetch(location)
    |> handle_result()
  end

  defp handle_result({:ok, result}), do: pretty_print(result)
  defp handle_result({_, msg}), do: Logger.error("Something went wrong: #{msg}")

  defp pretty_print({location, time, temperature}) do
    IO.puts("At #{time} the temperature at #{location} was #{temperature}")
  end
end