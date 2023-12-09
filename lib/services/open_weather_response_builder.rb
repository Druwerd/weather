# frozen_string_literal: true

module Services
  # Builds a response hash based on OpenWeather API data.
  class OpenWeatherResponseBuilder < Services::ResponseBuilder
    # Builds a response hash using the provided OpenWeather object.
    #
    # @param open_weather_obj [OpenWeather::Models::City::Weather] OpenWeather object containing weather data.
    # @return [Hash] Hash containing relevant weather information.
    # @raise [ArgumentError] if the provided object does not have the required interface.
    def build(open_weather_obj)
      raise ArgumentError unless valid_object?(open_weather_obj)

      open_weather_obj.main.to_h.merge(
        city_name: open_weather_obj.name,
        description: open_weather_obj.weather.first&.description
      ).symbolize_keys
    end

    private

    # Defines the required interface that the OpenWeather object must implement.
    #
    # @return [Array<Symbol>] Array of method names representing the required interface.
    def object_interface
      %i[main name weather]
    end

    # Checks if the provided object implements the required interface.
    #
    # @param object [Object] Object to be checked.
    # @return [Boolean] True if the object implements the required interface, false otherwise.
    def valid_object?(object)
      object_interface.all? do |method_name|
        object.respond_to?(method_name)
      end
    end
  end
end
