import Config

config :weather, current_weather_url_pattern: "https://w1.weather.gov/xml/current_obs/~s.xml"

config :logger, compile_time_purge_matching: [
    [level_lower_than: :info]
  ]