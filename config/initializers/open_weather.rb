# client = OpenWeather::Client.new(
#   api_key: "b69828c696ec3ff52fba5cd48bc82bf6"
# )

# # client.current_weather(city: 'New York', state: 'NY', country: 'US')

# # client.current_zip(10018, 'US') # => weather in New York, 10018


# # client.current_weather(zip: 91311, country: 'US', units: 'imperial') # => weather in New York, 10018
# {"coord"=>{"lon"=>-118.5914, "lat"=>34.2583},
#  "weather"=>
#   [{"icon_uri"=>#<URI::HTTP http://openweathermap.org/img/wn/01n@2x.png>,
#     "icon"=>"01n",
#     "id"=>800,
#     "main"=>"Clear",
#     "description"=>"clear sky"}],
#  "base"=>"stations",
#  "main"=>{"temp"=>288.37, "feels_like"=>287.02, "temp_min"=>286.73, "temp_max"=>290.15, "pressure"=>1010, "humidity"=>41},
#  "visibility"=>10000,
#  "wind"=>{"speed"=>8.75, "deg"=>360},
#  "clouds"=>{"all"=>0},
#  "dt"=>2023-12-08 01:01:17 UTC,
#  "sys"=>{"type"=>2, "id"=>2008939, "country"=>"US", "sunrise"=>2023-12-07 14:47:20 UTC, "sunset"=>2023-12-08 00:44:34 UTC},
#  "timezone"=>-28800,
#  "id"=>0,
#  "name"=>"Chatsworth",
#  "cod"=>200}

# http://api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid=b69828c696ec3ff52fba5cd48bc82bf6

# https://api.weatherbit.io/v2.0/current?lat=35.7796&lon=-78.6382&key=8f234668b91d4e6aae306d05989f21e2&include=minutely
# https://api.weatherbit.io/v2.0/current?key=8f234668b91d4e6aae306d05989f21e2&include=minutely&postal_code=27601&country=US
# https://api.weatherbit.io/v2.0/current?key=8f234668b91d4e6aae306d05989f21e2&include=minutely&postal_code=27601&country=US

# https://api.weatherbit.io/v2.0/forecast/minutely?key=8f234668b91d4e6aae306d05989f21e2&units=I&postal_code=91311&country=US


# https://api.openweathermap.org/data/2.5/weather?APPID=b69828c696ec3ff52fba5cd48bc82bf6
# https://api.openweathermap.org/data/2.5/weather?APPID=b69828c696ec3ff52fba5cd48bc82bf6

# http://api.openweathermap.org/geo/1.0/direct?q=Chatsworth,CA,US&limit=5&appid=b69828c696ec3ff52fba5cd48bc82bf6

# https://api.openweathermap.org/data/2.5/weather?zip=91311,us&appid=b69828c696ec3ff52fba5cd48bc82bf6&units=imperial
