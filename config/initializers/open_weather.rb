OpenWeather::Client.configure do |config|
  config.api_key = ENV.fetch('OPEN_WEATHER_API_KEY')
  config.user_agent = 'OpenWeather Ruby Client/1.0'
end
