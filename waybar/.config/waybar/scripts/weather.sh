#!/usr/bin/env bash

source ~/.owm
# UNITS="imperial"
UNITS="metric"
# TEMP_SYMBOL="F"
TEMP_SYMBOL="C"
# WIND_THRESH=25 # mph
WIND_THRESH=12 # m/s
# WIND_SYMBOL="mph"
WIND_SYMBOL="m/s"

# current weather data API
# url="https://api.openweathermap.org/data/2.5/weather?appid=${API_KEY}&units=${UNITS}&lang=en&q=$(echo $CITY | sed 's/ /%20/g'),${COUNTRY}"
url="https://api.openweathermap.org/data/2.5/weather?appid=${API_KEY}&id=${CITY_ID}&units=${UNITS}&lang=en"
resp=$(curl -s $url)
# parse JSON response
desc=$(echo $resp | jaq .weather[0].description | tr -d '"')
# temp=$(echo $resp | jq .main.temp)
feels_like=$(echo $resp | jaq .main.feels_like)
wind=$(echo $resp | jaq .wind.speed)

if [[ $(echo "$wind >= $WIND_THRESH" | bc -l) -eq 1 ]]; then
    wind_out=$(echo $wind | bc -l )
    # output="$desc | $temp$TEMP_SYMBOL |  $wind $WIND_SYMBOL"
    output="$desc | $feels_like$TEMP_SYMBOL |  $wind_out $WIND_SYMBOL"
else
    # output="$desc | $temp$TEMP_SYMBOL"
    output="$desc | $feels_like$TEMP_SYMBOL"
fi

printf '{"text": "%s", "class": "custom-weather"}' "$output"
