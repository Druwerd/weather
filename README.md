# README

Rails app to get weather from US address using OpenWeather API.

## Application Design
![diagram](./doc/weather-rails-app-2023-12-09-234332.png)

The Rails `WeatherController#current` action calls `Services::OpenWeatherConnector` which is encapsulates calling the OpenWeather API and build a response.

`OpenWeatherConnector` uses the [open-weather-ruby-client gem](https://github.com/dblock/open-weather-ruby-client).

`OpenWeatherConnector` uses `OpenWeatherResponseBuilder` to build a data response for the `WeatherController`. `OpenWeatherResponseBuilder` is based on the factory design pattern. This will allow us to easily extend the application to support multiple API data sources or multiple endpoint as we add features.

## Scalability
This application is stateless and runs without a database. There is a database version is on a separate branch: [with-db](https://github.com/Druwerd/weather/tree/with-db) for future feature expansion that may require a db.

To scale up the application you could setup your infrastructure architecture such that web application instances and Redis cluster nodes as are dynamically increased as load increases. See example diagram below.

Additionally you could server static assets such as images, css, javascript from a CDN.

![infra](./doc/app-infra-diagram.png)

## Dependencies
- Ruby 3
- Rails 7
- Redis

## App Setup for local development
```sh
bundle
bin/setup
cp .env.sample .env
```
Edit .env with your OpenWeather API key.

## Run app
`bin/dev`

## Testing
Run test with:

`rspec`

## Documentation
This project is documented using YARD.

Existing code documenation is located the `doc` folder of the project. See [doc/index.html](doc/index.html)

To regenerate the docs run: `rake yard`

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
