class Services::OpenWeatherResponseBuilder < Services::ResponseBuilder
  def build(open_weather_obj)
    raise ArgumentError unless valid_object?(open_weather_obj)
    open_weather_obj.main.to_h.merge(
      city_name: open_weather_obj.name,
      description: open_weather_obj.weather.first&.description,
    ).symbolize_keys
  end

  private

  def object_interface
    [:main, :name, :weather]
  end

  def valid_object?(object)
    object_interface.all? do |method_name|
      object.respond_to?(method_name)
    end
  end
end
