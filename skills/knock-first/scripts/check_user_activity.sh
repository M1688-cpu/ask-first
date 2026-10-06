#!/bin/bash
# check_user_activity.sh: report whether the user appears to be at this Mac.
# Prints one JSON object on stdout, exit 0. Failed probes degrade gracefully;
# on non-macOS or total failure the safe default is "user is present".

set -u

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

if [ "$(uname -s)" != "Darwin" ]; then
  echo '{"platform":"other","user_present":true,"note":"no detection on this platform; assuming user present"}'
  exit 0
fi

IDLE_THRESHOLD=300
MEDIA_PATTERN='([Zz]oom|Teams|[Ff]aceTime|[Qq]uickTime|VLC|OBS|[Ww]ebEx|[Ss]kype|[Gg]oogle [Mm]eet)'

# Seconds since the last keyboard/mouse input (HIDIdleTime is in nanoseconds).
idle=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}')
case "$idle" in
  ''|*[!0-9.]*) idle=0 ;;
esac
idle_int=$(printf '%.0f' "$idle" 2>/dev/null || echo 0)
case "$idle_int" in
  ''|*[!0-9]*) idle_int=0 ;;
esac

# Frontmost app. lsappinfo needs no accessibility permission.
front="unknown"
front_ref=$(lsappinfo front 2>/dev/null)
if [ -n "$front_ref" ]; then
  # Output looks like: "Dia" ASN:0x0-0x71b71b: (in front)
  front=$(lsappinfo info -only name "$front_ref" 2>/dev/null | awk -F'"' 'NR==1 {print $2}')
  [ -n "$front" ] || front="unknown"
fi

# Visible (non-background-only) app names. System Events may require
# Accessibility; on failure we continue with an empty list.
visible_raw=$(osascript -e 'tell application "System Events" to get name of every process whose background only is false' 2>/dev/null)
apps_json=""
media=false
if [ -n "$visible_raw" ]; then
  oldIFS="$IFS"
  IFS=','
  set -- $visible_raw
  IFS="$oldIFS"
  for app in "$@"; do
    app=$(printf '%s' "$app" | sed 's/^ *//; s/ *$//')
    [ -n "$app" ] || continue
    if printf '%s' "$app" | grep -Eq "$MEDIA_PATTERN"; then
      media=true
    fi
    if [ -n "$apps_json" ]; then apps_json="$apps_json, "; fi
    apps_json="$apps_json\"$(json_escape "$app")\""
  done
fi

# A meeting or media app running means the user is using the machine even
# with an idle keyboard (watching video, talking on a call).
if [ "$idle_int" -lt "$IDLE_THRESHOLD" ] || [ "$media" = "true" ]; then
  present=true
else
  present=false
fi

cat <<EOF
{"platform":"darwin","idle_seconds":$idle_int,"foreground_app":"$(json_escape "$front")","visible_apps":[$apps_json],"meeting_or_media_active":$media,"user_present":$present,"idle_threshold_seconds":$IDLE_THRESHOLD}
EOF
