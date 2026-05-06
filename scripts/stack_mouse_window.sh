#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

hs_bin="$HOME/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs"

notify() {
  osascript -e "display notification \"$1\" with title \"yabai stack\"" >/dev/null 2>&1 || true
}

reload_stackline() {
  if [ -x "$hs_bin" ]; then
    "$hs_bin" -c 'if stackline then stackline.forceRedraw = true; stackline.queryWindowState:start() end; if refreshYabaiStackBadges then refreshYabaiStackBadges() end' >/dev/null 2>&1 || true
  fi
}

if ! command -v yabai >/dev/null 2>&1; then
  notify "yabai is not installed"
  exit 0
fi

if ! yabai -m query --spaces >/dev/null 2>&1; then
  yabai --start-service >/dev/null 2>&1 || true
  sleep 1
  if ! yabai -m query --spaces >/dev/null 2>&1; then
    notify "yabai is not running"
    exit 0
  fi
fi

if yabai -m window --stack mouse >/dev/null 2>&1; then
  reload_stackline
  notify "stacked with window under mouse"
else
  notify "point at another normal window first"
fi
