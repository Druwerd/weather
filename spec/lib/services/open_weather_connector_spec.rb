require 'rails_helper'

RSpec.describe Services::OpenWeatherConnector do
  subject do
    described_class.new(
      response_builder: fake_response_builder
    )
  end

  let(:fake_client) do
    instance_double('OpenWeather::Client',
      current_weather: fake_open_weather_obj
    )
  end
  let(:fake_response_builder) do
    instance_double('Services::OpenWeatherResponseBuilder', build: {})
  end
  let(:fake_open_weather_obj) do
    double('OpenWeather::Object')
  end

  before do
    allow(OpenWeather::Client).to receive(:new)
      .and_return(fake_client)
    allow(fake_client).to receive(:current_weather)
      .and_return(fake_open_weather_obj)
  end

  describe '#call' do
    context 'with zip code' do
      it 'calls current_weather on the OpenWeather::Client' do
        expect(fake_client).to receive(:current_weather)
          .with(zip: '12345', country: 'US', units: 'imperial')
        subject.call(zip: '12345')
      end

      it 'calls build on the response builder' do
        expect(fake_response_builder).to receive(:build)
          .with(fake_open_weather_obj)
        subject.call(zip: '12345')
      end
    end

    context 'without zip code' do
      it 'raises exception' do
        expect { subject.call }.to raise_error(ArgumentError)
      end
    end

    context 'when client raises exception' do
      before do
        allow(OpenWeather::Client).to receive(:new)
          .and_raise(StandardError, "the system is down!")
      end

      it 'raises exception' do
        expect { subject.call(zip: '12345') }
          .to raise_error(StandardError)
          .with_message("the system is down!")
      end
    end
  end
end
