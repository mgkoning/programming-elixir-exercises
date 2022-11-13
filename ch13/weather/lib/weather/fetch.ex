defmodule Weather.Fetch do
	require Logger

  @weather_url Application.compile_env(:weather, :current_weather_url_pattern)

  def fetch(location) do
  	url = :io_lib.format(@weather_url, [location])
  	HTTPoison.get(url)
    |> handle_response()
  end

  defp handle_response({:error, msg}), do: {:error, msg}
  defp handle_response({_, %{status_code: status_code, body: body}}) do
    { status_code |> check_for_error(),
      body |> String.to_charlist() |> :xmerl_scan.string() |> read_values() }
  end
  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

  @desired_elements [:temperature_string, :observation_time_rfc822, :location]

  defp read_values({element, _}) do
    element
    |> get_content()
    |> elem(1)
    |> Enum.filter(&is_element/1)
    |> Enum.map(&get_content/1)
    |> Enum.filter(fn {name, _} -> Enum.member?(@desired_elements, name) end)
    |> Enum.map(fn {name, c} -> {name, c |> Enum.fetch!(0) |> get_content()} end)
    |> then(fn values -> {
      Keyword.get(values, :location),
      Keyword.get(values, :observation_time_rfc822),
      Keyword.get(values, :temperature_string) } end)
  end

  defp is_element({:xmlElement, _, _, _, _, _, _, _, _, _, _, _}), do: true
  defp is_element(_), do: false
  defp get_content({:xmlElement, name, _, _, _, _, _, _, children, _, _, _}), do: {name, children}
  defp get_content({:xmlText, _, _, _, text, _}), do: text
end