#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
pane_file="$state_dir/dual-pane"

notify() {
  osascript -e "display notification \"$1\" with title \"Dual Pane\"" >/dev/null 2>&1 || true
}

if [ ! -f "$pane_file" ]; then
  notify "Dual pane not active"
  exit 0
fi

# shellcheck source=/dev/null
. "$pane_file"

restore_window() {
  local id="$1" orig="$2"
  local x y w h
  x=$(printf '%s\n' "$orig" | cut -d: -f1)
  y=$(printf '%s\n' "$orig" | cut -d: -f2)
  w=$(printf '%s\n' "$orig" | cut -d: -f3)
  h=$(printf '%s\n' "$orig" | cut -d: -f4)
  yabai -m window "$id" --move abs:"${x}":"${y}" >/dev/null 2>&1 || true
  sleep 0.1
  yabai -m window "$id" --resize abs:"${w}":"${h}" >/dev/null 2>&1 || true
}

# Restore both workspace windows to their saved frames
if yabai -m query --windows --window "$slot_a_id" >/dev/null 2>&1; then
  restore_window "$slot_a_id" "$slot_a_orig"
fi
if yabai -m query --windows --window "$slot_b_id" >/dev/null 2>&1; then
  restore_window "$slot_b_id" "$slot_b_orig"
fi

rm -f "$pane_file"
notify "Dual pane deactivated"
