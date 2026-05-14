#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
pane_file="$state_dir/dual-pane"
log_file="$state_dir/dual-pane.log"

log() { echo "$(date '+%H:%M:%S') update: $*" >> "$log_file" 2>/dev/null || true; }

# Exit early if workspace not active
[ -f "$pane_file" ] || exit 0

# shellcheck source=/dev/null
. "$pane_file"

focused_id="${1:-}"
if [ -z "$focused_id" ]; then
  focused_id=$(yabai -m query --windows --window 2>/dev/null | jq -r '.id // empty' || true)
fi
[ -n "$focused_id" ] || exit 0

log "focused=$focused_id slot_a=$slot_a_id slot_b=$slot_b_id last=$last_focused_slot"

# Verify workspace windows still exist; deactivate cleanly if stale
if ! yabai -m query --windows --window "$slot_a_id" >/dev/null 2>&1 || \
   ! yabai -m query --windows --window "$slot_b_id" >/dev/null 2>&1; then
  log "stale window IDs, clearing pane_file"
  rm -f "$pane_file"
  exit 0
fi

write_pane() {
  tmp="$pane_file.$$"
  printf 'slot_a_id=%s\nslot_b_id=%s\nslot_a_orig=%s\nslot_b_orig=%s\nlast_focused_slot=%s\n' \
    "$1" "$2" "$3" "$4" "$5" > "$tmp"
  mv "$tmp" "$pane_file"
}

# Focused window is already in the workspace — update slot tracking only
if [ "$focused_id" = "$slot_a_id" ]; then
  write_pane "$slot_a_id" "$slot_b_id" "$slot_a_orig" "$slot_b_orig" "a"
  log "focused slot_a, updated tracking"
  exit 0
fi

if [ "$focused_id" = "$slot_b_id" ]; then
  write_pane "$slot_a_id" "$slot_b_id" "$slot_a_orig" "$slot_b_orig" "b"
  log "focused slot_b, updated tracking"
  exit 0
fi

log "external window focused, replacing last_focused_slot=$last_focused_slot"

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
  log "restored $id to $orig"
}

new_orig=$(yabai -m query --windows --window "$focused_id" 2>/dev/null \
  | jq -r '"\(.frame.x):\(.frame.y):\(.frame.w):\(.frame.h)"' \
  || echo "0:0:800:600")

# Ensure the incoming window is floating
is_floating=$(yabai -m query --windows --window "$focused_id" 2>/dev/null | jq -r '."is-floating"' || echo "true")
if [ "$is_floating" != "true" ]; then
  yabai -m window "$focused_id" --toggle float >/dev/null 2>&1 || true
fi

if [ "$last_focused_slot" = "a" ]; then
  restore_window "$slot_a_id" "$slot_a_orig"
  yabai -m window "$focused_id" --grid 1:8:0:0:3:1 >/dev/null 2>&1 || true
  write_pane "$focused_id" "$slot_b_id" "$new_orig" "$slot_b_orig" "a"
  log "slot_a replaced with $focused_id"
else
  restore_window "$slot_b_id" "$slot_b_orig"
  yabai -m window "$focused_id" --grid 1:8:3:0:3:1 >/dev/null 2>&1 || true
  write_pane "$slot_a_id" "$focused_id" "$slot_a_orig" "$new_orig" "b"
  log "slot_b replaced with $focused_id"
fi
