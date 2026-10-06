#!/bin/bash
# notify_done.sh "title" "message" [sound]
# Posts a macOS notification with a sound so the user notices the computer
# is being handed back. On other platforms, prints to stderr instead.

set -u

title="${1:-Testing done}"
message="${2:-The computer is yours again.}"
sound="${3:-Glass}"

if [ "$(uname -s)" = "Darwin" ]; then
  esc_title=$(printf '%s' "$title" | sed 's/\\/\\\\/g; s/"/\\"/g')
  esc_msg=$(printf '%s' "$message" | sed 's/\\/\\\\/g; s/"/\\"/g')
  osascript -e "display notification \"$esc_msg\" with title \"$esc_title\" sound name \"$sound\""
else
  echo "$title: $message" >&2
fi
