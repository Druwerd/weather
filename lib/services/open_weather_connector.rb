# frozen_string_literal: true

module Services
  # Connects to the OpenWeather API and retrieves weather data.
  class OpenWeatherConnector
    # Initializes a new OpenWeatherConnector instance.
    #
    # @param response_builder [Services::OpenWeatherResponseBuilder] The response builder to be used.
    def initialize(response_builder: Services::OpenWeatherResponseBuilder.new)
      @client = OpenWeather::Client.new
      @response_builder = response_builder
    end

    # Calls the OpenWeather API to retrieve weather data for the specified zip code.
    #
    # @param zip [String] The zip code for which weather data is requested.
    # @return [Hash] Hash containing relevant weather information.
    def call(zip:)
      open_weather_obj = @client.current_weather(
        zip: zip,
        country: 'US',
        units: 'imperial'
      )

      @response_builder.build(open_weather_obj)
    end
  end
end
