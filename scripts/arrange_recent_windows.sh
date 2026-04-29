#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

count="${1:-}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
history_file="$state_dir/focus-history"
layout_file="$state_dir/last-layout"

if ! command -v yabai >/dev/null 2>&1; then
  osascript -e 'display notification "yabai is not installed yet" with title "Window layout"'
  exit 0
fi

case "$count" in
  2|3|4) ;;
  *) echo "usage: $0 2|3|4" >&2; exit 2 ;;
esac

mkdir -p "$state_dir"
"$(dirname "$0")/track_yabai_focus.sh"

current_space=$(yabai -m query --spaces --space | jq -r '.index')
space_windows=$(yabai -m query --windows --space "$current_space")
space_ids=$(printf '%s\n' "$space_windows" | jq -r '.[].id')

ids=$(
  {
    [ -f "$history_file" ] && cat "$history_file" || true
    printf '%s\n' "$space_ids"
  } | awk 'NF && !seen[$0]++ { print }'
)

selected=$(
  printf '%s\n' "$ids" |
    awk 'NF' |
    while IFS= read -r id; do
      printf '%s\n' "$space_ids" | grep -qx "$id" && echo "$id"
    done |
    head -n "$count"
)

selected_count=$(printf '%s\n' "$selected" | awk 'NF { n++ } END { print n + 0 }')
if [ "$selected_count" -lt "$count" ]; then
  osascript -e "display notification \"Need $count windows on this space\" with title \"Window layout\""
  exit 0
fi

i=0
printf '%s\n' "$selected" | while IFS= read -r id; do
  [ -n "$id" ] || continue
  is_floating=$(yabai -m query --windows --window "$id" | jq -r '."is-floating"')
  if [ "$is_floating" != "true" ]; then
    yabai -m window "$id" --toggle float >/dev/null 2>&1 || true
  fi

  case "$count:$i" in
    2:0) grid="1:2:0:0:1:1" ;;
    2:1) grid="1:2:1:0:1:1" ;;
    3:0) grid="1:3:0:0:1:1" ;;
    3:1) grid="1:3:1:0:1:1" ;;
    3:2) grid="1:3:2:0:1:1" ;;
    4:0) grid="2:2:0:0:1:1" ;;
    4:1) grid="2:2:1:0:1:1" ;;
    4:2) grid="2:2:0:1:1:1" ;;
    4:3) grid="2:2:1:1:1:1" ;;
  esac

  yabai -m window "$id" --grid "$grid" >/dev/null 2>&1 || true
  i=$((i + 1))
done

{
  echo "$count"
  printf '%s\n' "$selected"
} > "$layout_file"
