class Services::OpenWeatherConnector
   def initialize(response_builder: Services::OpenWeatherResponseBuilder.new)
    @client = OpenWeather::Client.new
    @response_builder = response_builder
  end

  def call(zip:)
    open_weather_obj = @client.current_weather(
      zip: zip,
      country: 'US',
      units: 'imperial'
    )

    @response_builder.build(open_weather_obj)
  end
end
