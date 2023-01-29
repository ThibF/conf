#!/bin/sh

#Keep in mind: official values are 0.25, 1, 2.5
LIGHT_RAIN_TRESHOLD=0.1
MEDIUM_RAIN_TRESHOLD=0.25
MASSIVE_RAIN_TRESHOLD=1

is_bigger(){
  echo "$1 >= $2" | bc
}

is_int() {
    # usage: is_int "number"
    printf %d "$1" >/dev/null 2>&1
}
set -e

PRECIPITATIONS_VALUES=$(curl -s 'https://cdn-secure.buienalarm.nl/api/3.4/forecast.php?lat=52.0883&lon=5.0553&region=nl&unit=mm/u' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Origin: https://www.buienalarm.nl' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://www.buienalarm.nl/' | jq .precip)
#echo $PRECIPITATIONS_VALUES

_number_of_line_printed="0"
for _value in $PRECIPITATIONS_VALUES; do
  if ! is_int "${_value%%[,.]*}"; then
    continue
  fi

  if [ "$(is_bigger ${_value%%[,]*} ${MASSIVE_RAIN_TRESHOLD})" -eq 1 ]; then
    printf "⛈️"
  elif [ "$(is_bigger ${_value%%[,]*} ${MEDIUM_RAIN_TRESHOLD})" -eq 1 ]; then
    printf "🌧️"
  elif [ "$(is_bigger ${_value%%[,]*} ${LIGHT_RAIN_TRESHOLD})" -eq 1 ]; then
    printf "☁️"
  else
    printf "."
  fi
  _number_of_line_printed=$((_number_of_line_printed + 1))
  if [ "${_number_of_line_printed}" -gt 23 ]; then
    exit 0
  fi
  if [ "$((_number_of_line_printed % 6))" -eq 0 ]; then
    if [ "${BLOCK_BUTTON:-0}" -eq 1 ]; then
      printf "|"
    else
      exit 0
    fi
  fi
done

