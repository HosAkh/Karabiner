#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

hs_bin="$HOME/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs"

notify() {
  osascript -e "display notification \"$1\" with title \"yabai\"" >/dev/null 2>&1 || true
}

reload_stackline() {
  if [ -x "$hs_bin" ]; then
    "$hs_bin" -c 'if stackline then stackline.forceRedraw = true; stackline.queryWindowState:start() end; if refreshYabaiStackBadges then refreshYabaiStackBadges() end' >/dev/null 2>&1 || true
  fi
}

is_running() {
  yabai -m query --spaces >/dev/null 2>&1
}

case "${1:-toggle}" in
  start)
    yabai --start-service >/dev/null 2>&1 || true
    sleep 1
    if is_running; then
      reload_stackline
      notify "on"
    else
      notify "could not start; check Accessibility"
    fi
    ;;
  stop)
    yabai --stop-service >/dev/null 2>&1 || true
    reload_stackline
    notify "off"
    ;;
  toggle)
    if is_running; then
      "$0" stop
    else
      "$0" start
    fi
    ;;
  *)
    echo "usage: $0 [start|stop|toggle]" >&2
    exit 2
    ;;
esac
