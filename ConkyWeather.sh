#!/bin/bash

# v2.0 Closebox73
# This script is to get weather data from openweathermap.com in the form of a json file
# so that conky will still display the weather when offline even though it doesn't up to date

# Variables
# get your city id at https://openweathermap.org/find and replace
city_id=6159905
#lat=49.1064
#lon=-122.8251
# replace with yours
api_key=5ef1fab8b0dcee08c31198b75f457d30

#Mode Type
#mode_type=html
#mode_type=xml
mode_type=json

# choose between metric for Celcius or imperial for fahrenheit
unit=metric

# I'm not sure it will support all language,
lang=en

# Main command
url="api.openweathermap.org/data/2.5/weather?id=${city_id}&appid=${api_key}&mode=${mode_type}&cnt=5&units=${unit}&lang=${lang}"
curl ${url} -s -o ~/.config/conky/weather.${mode_type}


updated_unix_time="$(jq '.dt' ~/.config/conky/weather.${mode_type})"
timezone="$(jq '.timezone' ~/.config/conky/weather.${mode_type})"
adjusted_updated_time=$(($updated_unix_time + $timezone))

sunrise_unix_time="$(jq '.sys.sunrise' ~/.config/conky/weather.${mode_type})"
adjusted_sunrise_time=$(($sunrise_unix_time + $timezone))

sunset_unix_time="$(jq '.sys.sunset' ~/.config/conky/weather.${mode_type})"
adjusted_sunset_time=$(($sunset_unix_time + $timezone))

converted_updated_time=$(date -u -d "@$adjusted_updated_time" +"%Y-%m-%d %H:%M:%S")
echo "$converted_updated_time" > ~/.config/conky/updated.txt

converted_sunrise_time=$(date -u -d "@$adjusted_sunrise_time" +"%Y-%m-%d %H:%M:%S")
echo "$converted_sunrise_time" > ~/.config/conky/sunrise.txt

converted_sunset_time=$(date -u -d "@$adjusted_sunset_time" +"%Y-%m-%d %H:%M:%S")
echo "$converted_sunset_time" > ~/.config/conky/sunset.txt

exit
