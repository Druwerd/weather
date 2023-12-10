require 'rails_helper'

RSpec.describe WeatherController, type: :request do
  let(:fake_connector) do
    instance_double(Services::OpenWeatherConnector)
  end
  let(:fake_connector_response) do
    {
      temp: "75",
      feels_like: "72",
      temp_min: "65",
      temp_max: "77",
      city_name: 'City Name',
      description: 'clear sky'
    }
  end

  before do
    allow(Services::OpenWeatherConnector).to receive(:new)
      .and_return(fake_connector)
    allow(fake_connector).to receive(:call)
      .and_return(fake_connector_response)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get '/weather/index'
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #current' do
    context 'with valid params' do
      let(:params) do
        {
          street: Faker::Address.street_address,
          city: Faker::Address.city,
          state: Faker::Address.state,
          zip_code: Faker::Address.zip_code
        }
      end

      it 'renders the current template' do
        get '/weather/current', params: params
        expect(response).to render_template(:current)
        expect(response).to have_http_status(:success)
      end

      it 'sets the necessary instance variables' do
        get '/weather/current', params: params
        expect(assigns(:street)).to be_present
        expect(assigns(:city)).to be_present
        expect(assigns(:state)).to be_present
        expect(assigns(:zip_code)).to be_present
        expect(assigns(:weather)).to be_present
      end

      it 'caches the weather data' do
        Rails.cache.clear
        zip, _ = params[:zip_code].split("-")
        expect(Rails.cache).to receive(:fetch)
          .with(zip, expires_in: 30.minutes)
          .and_call_original
          .twice
        expect(fake_connector).to receive(:call).once
        get '/weather/current', params: params
        expect(flash.notice).to be_nil
        get '/weather/current', params: params
        expect(flash.notice).to eq("Cached")
      end

      it 'clears alerts and notices' do
        get '/weather/current', params: params
        expect(flash.alert).to be_nil
        expect(flash.notice).to be_nil
      end
    end

    context 'with invalid params' do
      it 'renders the index template' do
        get '/weather/current', params: {}
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:success)
      end

      it 'sets an alert for missing params' do
        get '/weather/current', params: {}
        expect(flash.alert).to eq('Missing Street, City, State, Zip code.')
      end

      context 'invalid zip code' do
        let(:params) do
          {
            street: Faker::Address.street_address,
            city: Faker::Address.city,
            state: Faker::Address.state,
            zip_code: "asdfsaf"
          }
        end

        it 'sets an alert for invalid zip code' do
          get '/weather/current', params: params
        expect(flash.alert).to eq('Invalid zip code.')
        end
      end
    end

    context 'when an error occurs' do
      let(:params) do
        {
          street: Faker::Address.street_address,
          city: Faker::Address.city,
          state: Faker::Address.state,
          zip_code: Faker::Address.zip_code
        }
      end

      before do
        allow(fake_connector)
          .to receive(:call).and_raise(StandardError, 'Some error')
      end

      it 'logs the error and raises it and has 500 status' do
        expect(Rails.logger).to receive(:error).with(/Something went wrong. Details: Some error/)
        get '/weather/current', params: params
        expect(flash.alert).to eq('Something went wrong. Please check you input and try again later.')
        expect(response).to have_http_status(:success)
      end
    end
  end
end
