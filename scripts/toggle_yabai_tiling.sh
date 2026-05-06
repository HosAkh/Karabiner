#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

notify() {
  osascript -e "display notification \"$1\" with title \"yabai tiling\"" >/dev/null 2>&1 || true
}

if ! command -v yabai >/dev/null 2>&1; then
  notify "yabai is not installed"
  exit 0
fi

if ! yabai -m query --spaces >/dev/null 2>&1; then
  yabai --start-service >/dev/null 2>&1 || true
  sleep 1
fi

if ! yabai -m query --spaces >/dev/null 2>&1; then
  notify "yabai is not running"
  exit 0
fi

current_layout=$(yabai -m query --spaces --space | jq -r '.type // empty')

case "$current_layout" in
  bsp|stack)
    yabai -m space --layout float >/dev/null 2>&1 || true
    notify "off"
    ;;
  *)
    yabai -m space --layout bsp >/dev/null 2>&1 || true
    notify "on"
    ;;
esac
