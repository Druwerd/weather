class Services::OpenWeatherConnector
  def initialize(api_key: ENV['OPEN_WEATHER_API_KEY'])
    @api_key = api_key
    @client = OpenWeather::Client.new(api_key: ENV['OPEN_WEATHER_API_KEY'])
  end

  def call(zip:)
    open_weather_obj = @client.current_weather(
      zip: zip,
      country: 'US',
      units: 'imperial'
    )

    build_response(open_weather_obj)
  end

  private

  def build_response(open_weather_obj)
    open_weather_obj.main.to_h.merge({
      city_name: open_weather_obj.name,
      description: open_weather_obj.weather.first&.description,
    }).symbolize_keys
  end
end

