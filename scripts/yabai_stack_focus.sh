#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

direction="${1:-}"

notify() {
  osascript -e "display notification \"$1\" with title \"yabai stack\"" >/dev/null 2>&1 || true
}

case "$direction" in
  prev|next) ;;
  *) echo "usage: $0 prev|next" >&2; exit 2 ;;
esac

if ! yabai -m query --spaces >/dev/null 2>&1; then
  notify "yabai is not running"
  exit 0
fi

if ! yabai -m window --focus "stack.$direction" >/dev/null 2>&1; then
  notify "focused window is not in a stack"
fi
