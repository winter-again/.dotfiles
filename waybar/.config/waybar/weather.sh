#!/usr/bin/env bash

API_KEY=$(cat $HOME/.owm-key)
CITY=$(cat $HOME/.owm-loc)
COUNTRY="US"
UNITS="imperial"
WIND_THRESH=25

url="https://api.openweathermap.org/data/2.5/weather?appid=$API_KEY&units=$UNITS&lang=en&q=$(echo $CITY | sed 's/ /%20/g'),$COUNTRY"
resp=$(curl -s $url)
# parse JSON response
desc=$(echo $resp | jq .weather[0].description | tr -d '"')
temp=$(echo $resp | jq .main.temp)
# feels_like=$(echo $resp | jq .main.feels_like)
wind=$(echo $resp | jq .wind.speed)

if [[ $(echo $wind >= $WIND_THRESH | bc -l) -eq 1 ]]; then
    output="$desc ~ $tempF ~  $wind mph"
else
    output="$desc ~ $tempF"
fi


printf '{"text": "%s", "class": "custom-weather" }' "$output"
