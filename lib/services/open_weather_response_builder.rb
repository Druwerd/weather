class Services::OpenWeatherResponseBuilder < Services::ResponseBuilder
  def build(open_weather_obj)
    open_weather_obj.main.to_h.merge(
      city_name: open_weather_obj.name,
      description: open_weather_obj.weather.first&.description,
    ).symbolize_keys
  end
end
