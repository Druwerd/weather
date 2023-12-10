# README

Rails app to get weather from US address using OpenWeather API.

## Application Design
![diagram](./doc/weather-rails-app-2023-12-09-234332.png)

Rails `WeatherController#current` calls `Services::OpenWeatherConnector` which is responsible for calling the OpenWeather API.

`OpenWeatherConnector` uses the [open-weather-ruby-client gem](https://github.com/dblock/open-weather-ruby-client).

`OpenWeatherConnector` uses `OpenWeatherResponseBuilder` to build a data response for the `WeatherController`. `OpenWeatherResponseBuilder` is based on the factory design pattern. This will allow us to easily extend the application to support multiple API data sources or multiple endpoint as we add features.

## Dependencies
- Ruby 3
- Rails 7
- Redis
- Postgres

## App Setup
```sh
bundle install
rails db:setup
rails s
```

## Testing
`rspec`

## Screenshots
Homepage
![homepage](./doc/screenshots/homepage.png)

With Invalid Fields
![valid fields](./doc/screenshots/invalid-fields.png)

With Valid Fields
![valid fields](./doc/screenshots/valid-fields.png)

Cache Miss
![cache miss](./doc/screenshots/cache-miss.png)

Cache Hit
![cache hit](./doc/screenshots/cache-hit.png)
