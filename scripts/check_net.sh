#!/bin/sh
# Check the network
# Raspberry Pi seems to loose network connectivity if the router goes down for some reason.
# This script will monitor the network (router in particular) availability and it detects that the router 
# is not reachable then it restarts the network interface
#
# Need to be run as root. If scheduling in crontab then either choose roots crontab or
# the system crontab /etc/crontab
#
ROUTER="192.168.1.1"
IFACE="wlan0"
LOGGER="/usr/bin/logger --tag RPI_NET"

# Send 5 ping packaets to the router
/bin/ping -c5 $ROUTER >/dev/null 2>&1

if [ $? != 0 ]
then
  $LOGGER "Restarting wlan0 interface"
  /sbin/ifdown $IFACE
  sleep 5
  /sbin/ifup --force $IFACE
else
  $LOGGER "Router pingable" 
fi
