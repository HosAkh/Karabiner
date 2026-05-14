#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
pane_file="$state_dir/dual-pane"
history_file="$state_dir/focus-history"
log_file="$state_dir/dual-pane.log"

log() { echo "$(date '+%H:%M:%S') $*" >> "$log_file"; }

notify() {
  osascript -e "display notification \"$1\" with title \"Dual Pane\"" >/dev/null 2>&1 || true
}

mkdir -p "$state_dir"
: > "$log_file"
log "activate: starting"

if ! command -v yabai >/dev/null 2>&1; then
  log "yabai not found in PATH=$PATH"
  notify "yabai not installed"
  exit 0
fi

if ! yabai -m query --spaces >/dev/null 2>&1; then
  log "yabai not responding"
  notify "yabai not running"
  exit 0
fi

"$(dirname "$0")/track_yabai_focus.sh"

current_space=$(yabai -m query --spaces --space | jq -r '.index')
log "current_space=$current_space"

space_windows=$(yabai -m query --windows --space "$current_space")
space_ids=$(printf '%s\n' "$space_windows" | jq -r '.[] | select(."is-minimized" == false) | .id')
log "space_ids=$(printf '%s' "$space_ids" | tr '\n' ' ')"

# Pick 2 most recently used windows on this space
ids=$(
  {
    [ -f "$history_file" ] && cat "$history_file" || true
    printf '%s\n' "$space_ids"
  } | awk 'NF && !seen[$0]++'
)

selected=$(
  printf '%s\n' "$ids" | awk 'NF' |
    while IFS= read -r id; do
      printf '%s\n' "$space_ids" | grep -qx "$id" && echo "$id" || true
    done |
    head -n 2
) || true

count=$(printf '%s\n' "$selected" | awk 'NF { n++ } END { print n + 0 }')
log "selected=$count windows: $(printf '%s' "$selected" | tr '\n' ' ')"

if [ "$count" -lt 2 ]; then
  notify "Need at least 2 windows on this space"
  log "aborting: not enough windows"
  exit 0
fi

slot_a=$(printf '%s\n' "$selected" | sed -n '1p')
slot_b=$(printf '%s\n' "$selected" | sed -n '2p')
log "slot_a=$slot_a slot_b=$slot_b"

# Save original frames before moving anything
orig_a=$(yabai -m query --windows --window "$slot_a" | jq -r '"\(.frame.x):\(.frame.y):\(.frame.w):\(.frame.h)"')
orig_b=$(yabai -m query --windows --window "$slot_b" | jq -r '"\(.frame.x):\(.frame.y):\(.frame.w):\(.frame.h)"')
log "orig_a=$orig_a orig_b=$orig_b"

# Ensure floating (yabai layout is float so this is usually a no-op)
is_a_floating=$(yabai -m query --windows --window "$slot_a" | jq -r '."is-floating"')
if [ "$is_a_floating" != "true" ]; then
  yabai -m window "$slot_a" --toggle float >/dev/null 2>&1 || true
fi
is_b_floating=$(yabai -m query --windows --window "$slot_b" | jq -r '."is-floating"')
if [ "$is_b_floating" != "true" ]; then
  yabai -m window "$slot_b" --toggle float >/dev/null 2>&1 || true
fi

# Centered: 1/8 margin | left 3/8 | right 3/8 | 1/8 margin
# Small sleep needed between commands — yabai drops rapid sequential moves
yabai -m window "$slot_a" --grid 1:8:1:0:3:1 >/dev/null 2>&1 || true
sleep 0.1
yabai -m window "$slot_b" --grid 1:8:4:0:3:1 >/dev/null 2>&1 || true
log "grid commands issued"

tmp="$pane_file.$$"
printf 'slot_a_id=%s\nslot_b_id=%s\nslot_a_orig=%s\nslot_b_orig=%s\nlast_focused_slot=a\n' \
  "$slot_a" "$slot_b" "$orig_a" "$orig_b" > "$tmp"
mv "$tmp" "$pane_file"
log "pane_file written"

notify "Dual pane activated"
log "done"
