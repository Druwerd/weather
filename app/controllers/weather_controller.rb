class WeatherController < ApplicationController
  before_action :clear_notices

  def index
  end

  def current
    if required_params.all?{|p| params[p].present? }
      # @street = params[:street]
      # @city = params[:city]
      # @state = params[:state]
      @zip_code = params[:zip_code]

      flash.notice = "Cached"
      @weather = Rails.cache.fetch(@zip_code.to_s, expires_in: 30.minutes) do
        flash.notice = nil
        weather_connector.call(zip: @zip_code)
      end
    else
      missing_field_names = required_params.map{|p| p.to_s.humanize }.join(",")
      flash.alert = "Missing #{missing_field_names}"
      render :index
    end
  end

  private

  def set_weather_variables
    @current_temp = @weather["temp"]
    @feels_like = @weather["feels_like"]
    @temp_min = @weather["temp_min"]
    @temp_max = @weather["temp_max"]
  end


  def clear_notices
    flash.alert = nil
    flash.notice = nil
  end

  def weather_connector
    @weather_connect ||= Services::OpenWeatherConnector.new
  end

  def weather_params
    params.require(:weather).permit(:street, :city, :state, :zip_code)
  end

  def required_params
    [:zip_code]
  end
end
