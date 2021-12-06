#!/bin/sh
#
# Run wifi-connect periodically
#

WIFI_CONNECTED=$(/usr/sbin/iw wlan0 link | grep SSID | awk '{print $2}')
if [ -z ${WIFI_CONNECTED} ]; then
    echo No wifi connection. Launching wifi-connect
    wifi-connect -u /usr/share/wifi-connect/ui/
else
    echo Connected to ${WIFI_CONNECTED}
    echo Not launching wifi-connect
fi
