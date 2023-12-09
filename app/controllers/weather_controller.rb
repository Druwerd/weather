class WeatherController < ApplicationController
  before_action :clear_notices, :set_form_fields

  def index
  end

  def current
    if valid_params?
      @zip_code = weather_params[:zip_code]

      flash.notice = "Cached"
      @weather = Rails.cache.fetch(@zip_code.to_s, expires_in: 30.minutes) do
        flash.notice = nil
        weather_connector.call(zip: @zip_code)
      end
    else
      alert_missing_params
      render :index
    end
  end

  private

  def set_form_fields
    @street = weather_params[:street]
    @city = weather_params[:city]
    @state = weather_params[:state]
    @zip_code = weather_params[:zip_code]
  end

  def valid_params?
    required_params.all? { |p| weather_params[p].present? }
  end

  def alert_missing_params
    missing_params = required_params.select{ |p| weather_params[p].blank? }
    missing_param_names = missing_params
      .map{ |p| p.to_s.humanize }.join(", ")

    flash.alert = "Missing #{missing_param_names}"
  end

  def clear_notices
    flash.alert = nil
    flash.notice = nil
  end

  def weather_connector
    @weather_connect ||= Services::OpenWeatherConnector.new
  end

  def weather_params
    params.permit(*required_params)
  end

  def required_params
    [:street, :city, :state, :zip_code]
  end
end
