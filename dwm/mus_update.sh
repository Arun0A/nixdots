#!/bin/sh

sleep 0.2

title=""
i=0
while [ "$i" -lt 10 ]; do
  title=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null | sed 's/^ - //; s/ - $//')
  if [ -n "$title" ]; then
    break
  fi

  title=$(playerctl metadata --format '{{title}}' 2>/dev/null)
  if [ -n "$title" ]; then
    break
  fi

  sleep 0.1
  i=$((i + 1))
done

if [ -z "$title" ]; then
  title=$(cat /tmp/status_mus 2>/dev/null || echo "")
fi

echo "$title" >/tmp/status_mus

base=$(cat /tmp/status_base 2>/dev/null || echo "")

if [ -n "$title" ]; then
  xsetroot -name "${title} | $base"
else
  xsetroot -name "$base"
fi
