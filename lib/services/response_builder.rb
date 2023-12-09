class Services::ResponseBuilder
  def build(open_weather_obj)
    raise NotImplementedError, 'Subclasses must implement the build method'
  end
end
