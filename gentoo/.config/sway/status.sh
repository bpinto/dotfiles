#!/bin/bash

function wireguard
{

    WIREGUARD=$(wg show 2>&1)
    if [ -z "$WIREGUARD" ]; then
      echo '{'
      echo '"name" : "wireguard",'
      echo '"color" : "#BD2C40",'
      echo '"full_text" : "  ",'
      echo '"short_text" : "  "'
      echo '},'
    else
      echo '{'
      echo '"name" : "wireguard",'
      echo '"color" : "#DFDFDF",'
      echo '"full_text" : "  ",'
      echo '"short_text" : "  "'
      echo '},'
    fi
}

function battery
{
    BAT=$(for dev in $(upower -e); do upower -i $dev; done | grep -m 1 percentage | awk '{ print $2; }')
    if [ -z $BAT ]; then
        return
    fi

    echo '{'
    echo '"name" : "battery",'
    if [ "$BAT" == '100%' ]; then
      echo '"color" : "#DFDFDF",'
      echo '"full_text" : "  '$BAT' "'
    else
      echo '"color" : "#FFA900",'
      echo '"full_text" : "  '$BAT' "'
    fi
    echo '},'
}

function datetime
{
    echo '{'
    echo '"name" : "datetime",'
    echo '"color" : "#DFDFDF",'
    echo '"full_text" : "  '$(date +'%b %d %H:%M')'",'
    echo '"short_text" : " '$(date +'%b %d %H:%M')'"'
    echo '}'
}

echo '{"version":1}'

echo '['

while true; do
    echo '['
    echo $(wireguard)
    echo $(battery)
    echo $(datetime)
    echo '],'
    sleep 1
done

echo ']'
