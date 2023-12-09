class WeatherController < ApplicationController
  before_action :clear_notices, :set_form_fields

  def index
  end

  def current
    if valid_params?
      @zip_code, _ = weather_params[:zip_code].split("-")

      flash.notice = "Cached"
      @weather = Rails.cache.fetch(@zip_code.to_s, expires_in: 30.minutes) do
        flash.notice = nil
        weather_connector.call(zip: @zip_code)
      end
    else
      alert_invalid_params
      render :index
    end
  rescue StandardError => e
    Rails.logger.error("Something went wrong. Details: #{e.message}")
    # TODO: create alert
    raise e # reraise error to render Rails error page
  end

  private

  def set_form_fields
    @street = weather_params[:street]
    @city = weather_params[:city]
    @state = weather_params[:state]
    @zip_code = weather_params[:zip_code]
  end

  def valid_params?
    required_params.all? { |p| weather_params[p].present? } &&
      valid_zip?
  end

  def valid_zip?
    weather_params[:zip_code].to_s.match?(/^\d{5}(\-\d{4})?$/)
  end

  def alert_invalid_params
    missing_params = required_params.select{ |p| weather_params[p].blank? }
    missing_param_names = missing_params
      .map{ |p| p.to_s.humanize }.join(", ")

    message = ""
    message += "Missing #{missing_param_names}. " if missing_params.any?
    message += "Invalid zip code." if weather_params[:zip_code].present? && !valid_zip?

    flash.alert = message.strip
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
