require 'rails_helper'

RSpec.describe Services::OpenWeatherResponseBuilder do
  subject { described_class.new }

  let(:fake_open_weather_obj) do
    instance_double(OpenWeather::Models::City::Weather,
      main: double('Main', to_h: {
        temp: "75",
        feels_like: "72",
        temp_min: "65",
        temp_max: "77"
      }),
      name: 'City Name',
      weather: [double('Weather', description: 'clear sky')]
    )
  end

  describe '#build' do
    context 'with valid object' do
      let(:expected_result) do
        {
          temp: "75",
          feels_like: "72",
          temp_min: "65",
          temp_max: "77",
          city_name: 'City Name',
          description: 'clear sky'
        }
      end

      it 'builds a hash with required weather information' do
        expect(subject.build(fake_open_weather_obj))
          .to eq(expected_result)
      end
    end

    context 'invalid object' do
      it 'raises Argument error' do
        expect{ subject.build("foo") }
          .to raise_error(ArgumentError)
      end
    end
  end
end
