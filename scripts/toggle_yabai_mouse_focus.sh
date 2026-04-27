#!/usr/bin/env sh
set -eu

state_file="${TMPDIR:-/tmp}/codex-yabai-focus-follows-mouse"

if ! command -v yabai >/dev/null 2>&1; then
  osascript -e 'display notification "yabai is not installed yet" with title "Hyper+M"'
  exit 0
fi

if [ -f "$state_file" ]; then
  yabai -m config focus_follows_mouse off
  rm -f "$state_file"
  osascript -e 'display notification "focus follows mouse off" with title "Hyper+M"'
else
  yabai -m config focus_follows_mouse autofocus
  : > "$state_file"
  osascript -e 'display notification "focus follows mouse on" with title "Hyper+M"'
fi
