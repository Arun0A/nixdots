#!/bin/sh
PREFERRED_PLAYERS="mpd vivaldi brave"
LAST_ACTIVE_FILE="/tmp/last_active_player"

# Determine target player
target_player=""

# 1. Check if any player is actively playing
for player in $PREFERRED_PLAYERS; do
  if playerctl -p "$player" status 2>/dev/null | grep -q "^Playing$"; then
    target_player="$player"
    break
  fi
done

if [ -z "$target_player" ]; then
  all_players=$(playerctl -l 2>/dev/null)
  for player in $all_players; do
    is_pref=""
    for pref in $PREFERRED_PLAYERS; do
      if [ "$player" = "$pref" ] || echo "$player" | grep -q "^${pref}\."; then
        is_pref="$pref"
        break
      fi
    done
    if [ -z "$is_pref" ]; then
      if playerctl -p "$player" status 2>/dev/null | grep -q "^Playing$"; then
        target_player="$player"
        break
      fi
    fi
  done
fi

# 2. Check last active player if nothing is playing
if [ -z "$target_player" ] && [ -f "$LAST_ACTIVE_FILE" ]; then
  last_player=$(cat "$LAST_ACTIVE_FILE")
  if [ -n "$last_player" ]; then
    # Check if this player is still available in the list
    if playerctl -l 2>/dev/null | grep -qi "^${last_player}"; then
      target_player="$last_player"
    fi
  fi
fi

# 3. Fallback to priority list for paused/stopped players
if [ -z "$target_player" ]; then
  for player in $PREFERRED_PLAYERS; do
    if playerctl -p "$player" status 2>/dev/null >/dev/null; then
      target_player="$player"
      break
    fi
  done
fi

if [ -z "$target_player" ]; then
  for player in $all_players; do
    is_pref=""
    for pref in $PREFERRED_PLAYERS; do
      if [ "$player" = "$pref" ] || echo "$player" | grep -q "^${pref}\."; then
        is_pref="$pref"
        break
      fi
    done
    if [ -z "$is_pref" ]; then
      if playerctl -p "$player" status 2>/dev/null >/dev/null; then
        target_player="$player"
        break
      fi
    fi
  done
fi

# If we still don't have a target player, default to first preferred player that exists
if [ -z "$target_player" ]; then
  target_player="mpd"
fi

# If this is a control command (not status/metadata), update the last active file
is_query=0
if [ "$1" = "status" ] || [ "$1" = "metadata" ]; then
  is_query=1
fi

if [ "$is_query" -eq 0 ] && [ -n "$target_player" ]; then
  # Write the base name (without instance ID) to target it next time
  base_player=""
  for pref in $PREFERRED_PLAYERS; do
    if [ "$target_player" = "$pref" ] || echo "$target_player" | grep -q "^${pref}\."; then
      base_player="$pref"
      break
    fi
  done
  if [ -n "$base_player" ]; then
    echo "$base_player" > "$LAST_ACTIVE_FILE"
  else
    echo "$target_player" | cut -d. -f1 > "$LAST_ACTIVE_FILE"
  fi
fi

# Execute command
exec playerctl -p "$target_player" "$@"
