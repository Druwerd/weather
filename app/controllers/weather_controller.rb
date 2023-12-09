# frozen_string_literal: true

# Controller for handling weather-related actions.
class WeatherController < ApplicationController
  # Clears alert and notice messages before certain actions.
  before_action :clear_notices, :set_form_fields

  # Renders the index view.
  def index
  end

  # Retrieves and displays current weather based on user-input parameters.
  #
  # If valid parameters are provided, it sets instance variables for the view,
  # caches the weather data, and renders the current view. Otherwise, it alerts
  # the user about missing or invalid parameters and renders the index view.
  #
  # @raise [StandardError] Reraised to render Rails error page.
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

  # Sets instance variables for form fields based on user-input parameters.
  def set_form_fields
    @street = weather_params[:street]
    @city = weather_params[:city]
    @state = weather_params[:state]
    @zip_code = weather_params[:zip_code]
  end

  # Checks if the provided parameters are valid.
  #
  # Parameters are considered valid if all required parameters are present,
  # and the zip code follows the correct format.
  #
  # @return [Boolean] True if parameters are valid, false otherwise.
  def valid_params?
    required_params.all? { |p| weather_params[p].present? } &&
      valid_zip?
  end

  # Checks if the provided zip code is in the correct format.
  #
  # @return [Boolean] True if the zip code is in the correct format, false otherwise.
  def valid_zip?
    weather_params[:zip_code].to_s.match?(/^\d{5}(\-\d{4})?$/)
  end

  # Alerts the user about missing or invalid parameters.
  def alert_invalid_params
    missing_params = required_params.select { |p| weather_params[p].blank? }
    missing_param_names = missing_params
      .map { |p| p.to_s.humanize }.join(", ")

    message = ""
    message += "Missing #{missing_param_names}. " if missing_params.any?
    message += "Invalid zip code." if weather_params[:zip_code].present? && !valid_zip?

    flash.alert = message.strip
  end

  # Clears alert and notice messages.
  def clear_notices
    flash.alert = nil
    flash.notice = nil
  end

  # Retrieves the OpenWeatherConnector instance.
  #
  # @return [Services::OpenWeatherConnector] The OpenWeatherConnector instance.
  def weather_connector
    @weather_connect ||= Services::OpenWeatherConnector.new
  end

  # Retrieves the permitted weather parameters.
  #
  # @return [ActionController::Parameters] Permitted weather parameters.
  def weather_params
    params.permit(*required_params)
  end

  # Defines the required parameters for weather-related actions.
  #
  # @return [Array<Symbol>] Array of symbols representing required parameters.
  def required_params
    [:street, :city, :state, :zip_code]
  end
end
