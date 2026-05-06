#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

hs_bin="$HOME/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
history_file="$state_dir/focus-history"

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

"$(dirname "$0")/track_yabai_focus.sh"

current_id=$(yabai -m query --windows --window | jq -r '.id // empty')
current_space=$(yabai -m query --spaces --space | jq -r '.index')
space_ids=$(yabai -m query --windows --space "$current_space" | jq -r '.[] | select(."is-floating" == false and ."is-minimized" == false) | .id')

target_id=$(
  {
    [ -f "$history_file" ] && cat "$history_file" || true
    printf '%s\n' "$space_ids"
  } |
    awk -v current="$current_id" 'NF && $0 != current && !seen[$0]++ { print }' |
    while IFS= read -r id; do
      printf '%s\n' "$space_ids" | grep -qx "$id" && echo "$id"
    done |
    head -n 1
)

if [ -z "$target_id" ]; then
  notify "focus two normal windows first"
  exit 0
fi

if yabai -m window --stack "$target_id" >/dev/null 2>&1; then
  reload_stackline
  notify "stacked with recent window"
else
  notify "focus two normal windows first"
fi
