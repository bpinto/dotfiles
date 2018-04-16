#!/bin/bash

function wireguard
{

    WIREGUARD=$(wg show 2>&1)
    if [ -z "$WIREGUARD" ]
    then
      echo '{'
      echo '"name" : "wireguard",'
      echo '"color" : "#ff0000",'
      echo '"full_text" : "VPN: No",'
      echo '"short_text" : "VPN: No"'
      echo '},'
    else
      echo '{'
      echo '"name" : "wireguard",'
      echo '"color" : "#00ff00",'
      echo '"full_text" : "VPN: Yes",'
      echo '"short_text" : "VPN: Yes"'
      echo '},'
    fi
}

function battery
{
    BAT=$(for dev in $(upower -e); do upower -i $dev; done | grep -m 1 percentage | awk '{ print $2; }')
    if [ -z $BAT ]
    then
        return
    fi
    echo '{'
    echo '"name" : "battery",'
    echo '"color" : "#00ff00",'
    echo '"full_text" : "Bat: '$BAT'"'
    echo '},'
}

function datetime
{
    echo '{'
    echo '"name" : "datetime",'
    echo '"color" : "#00ffff",'
    echo '"full_text" : "'$(date +'%Y-%m-%d %H:%M:%S')'",'
    echo '"short_text" : "'$(date +'%H:%M:%S')'"'
    echo '}'
}

echo '{"version":1}'

echo '['

while true
do
    echo '['
    echo $(wireguard)
    echo $(battery)
    echo $(datetime)
    echo '],'
    sleep 1
done

echo ']'
