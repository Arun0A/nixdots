#!/bin/sh

while true; do
 
  # Battery with status
  battery=$(cat /sys/class/power_supply/BAT1/capacity)%
  bat_stat=`cat /sys/class/power_supply/BAT1/status`
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

  datetime=$(date '+%a %d %b %H:%M')

  # CPU temperature (assumes lm_sensors)
  cpu_temp=$(sensors | grep -m 1 'Package' | awk '{print $4}')
  cpu_fields=$(awk '/^cpu / {print $2" "$3" "$4" "$5" "$6" "$7" "$8" "$9; exit}' /proc/stat)
  set -- $cpu_fields
  cpu_user=$1
  cpu_nice=$2
  cpu_system=$3
  cpu_idle=$4
  cpu_iowait=$5
  cpu_irq=$6
  cpu_softirq=$7
  cpu_steal=$8
  cpu_idle_all=$((cpu_idle + cpu_iowait))
  cpu_total=$((cpu_user + cpu_nice + cpu_system + cpu_idle + cpu_iowait + cpu_irq + cpu_softirq + cpu_steal))

  cpu_usage="0%"
  if [ -r /tmp/status_cpu_prev ]; then
    read -r prev_idle prev_total < /tmp/status_cpu_prev
    totald=$((cpu_total - prev_total))
    idled=$((cpu_idle_all - prev_idle))
    if [ "$totald" -gt 0 ]; then
      usage=$((100 * (totald - idled) / totald))
      cpu_usage="${usage}%"
    fi
  fi
  echo "$cpu_idle_all $cpu_total" > /tmp/status_cpu_prev

  # Memory usage
  # mem_used=$(free -h | awk '/^Mem:/ {print $3 "/" $2}') # shows used/total
  mem_used=$(free -h | awk '/^Mem:/ {print $3}')

  # Network interface status (assuming you use wlan0 or enp*)
  net=$(ip link show | awk '/state UP/ {print $2}' | sed 's/://' | head -n 1)
  ssid=$(nmcli c | grep $(ip link show | awk '/state UP/ {print $2}' | sed 's/://' | head -n 1) | awk '{print $1}')
  net_status=${net:-"NoNet"}
  ip=$(ip -4 addr show "$net" | awk '/inet / {print $2}' | cut -d/ -f1)
  warp_status=$([[ -n "$(nmcli c | grep CloudflareWARP)" ]] && echo "*" || echo "")

  if playerctl status 2>/dev/null | grep -q "^Playing$"; then
    mus=$(playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null | sed 's/^ - //; s/ - $//')

    if [ -z "$mus" ]; then
      mus=$(playerctl metadata --format '{{title}}' 2>/dev/null)
    fi

    maxlen=40

    if [ ${#mus} -gt $maxlen ]; then
      mus="${mus:0:$maxlen}..."
    fi

    echo "$mus" >/tmp/status_mus
  else
    rm -f /tmp/status_mus
  fi

  # Initialize vol
  vol=$(cat /tmp/status_vol)
  mus=$(cat /tmp/status_mus 2>/dev/null || echo "")

  # Write the base status to /tmp/status_base
  echo "$warp_status$ssid $ip | $mem_used | ${cpu_usage::-1}${cpu_temp:0:-4} | $battery | $datetime" >/tmp/status_base
  if [ -n "$mus" ]; then
    xsetroot -name "${mus} | $warp_status$ssid $ip | $mem_used | ${cpu_usage::-1}${cpu_temp:0:-4} | $battery | $datetime"
  else
    xsetroot -name "$warp_status$ssid $ip | $mem_used | ${cpu_usage::-1}${cpu_temp:0:-4} | $battery | $datetime"
  fi
  sleep 30
done
