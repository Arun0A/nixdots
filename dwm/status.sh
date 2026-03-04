#!/bin/sh

while true; do
 
  # Battery with status
  battery=$(cat /sys/class/power_supply/BAT0/capacity)%
  bat_stat=`cat /sys/class/power_supply/BAT0/status`
  if [[ "$bat_stat" == "Charging"  ]]; then
    battery+="*"
  elif [[ "$bat_stat" == "Full"  ]]; then
    battery+="*"
  elif [[ "$bat_stat" == "Not charging" ]]; then
    battery+="!"
  elif [[ "$bat_stat" == "Discharging" ]]; then
    battery+=""
  else
    battery+="E"
  fi

  datetime=$(date '+%a %d %b %I:%M %p')

  # CPU temperature (assumes lm_sensors)
  cpu_temp=$(sensors | grep -m 1 'Package' | awk '{print $4}')

  # Memory usage
  mem_used=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

  # Network interface status (assuming you use wlan0 or enp*)
  net=$(ip link show | awk '/state UP/ {print $2}' | sed 's/://')
  net_status=${net:-"NoNet"}
  ip=$(ip -4 addr show "$net" | awk '/inet / {print $2}' | cut -d/ -f1)

  # Initialize vol
  vol=$(cat /tmp/status_vol)

  # Write the base status to /tmp/status_base
  echo "$net_status $ip | $mem_used | $cpu_temp | $battery | $datetime" >/tmp/status_base
  xsetroot -name "$net_status $ip | $mem_used | $cpu_temp | $battery | $datetime"
  sleep 30
done
