#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
layout_file="$state_dir/last-layout"

if ! command -v yabai >/dev/null 2>&1; then
  osascript -e 'display notification "yabai is not installed yet" with title "Window layout"'
  exit 0
fi

if [ ! -f "$layout_file" ]; then
  yabai -m space --rotate 90 >/dev/null 2>&1 || true
  exit 0
fi

count=$(sed -n '1p' "$layout_file")
ids=$(sed -n '2,$p' "$layout_file" | awk 'NF')
selected_count=$(printf '%s\n' "$ids" | awk 'NF { n++ } END { print n + 0 }')

if [ "$selected_count" -lt 2 ]; then
  yabai -m space --rotate 90 >/dev/null 2>&1 || true
  exit 0
fi

rotated=$(
  {
    printf '%s\n' "$ids" | sed -n '2,$p'
    printf '%s\n' "$ids" | sed -n '1p'
  } | awk 'NF'
)

{
  echo "$count"
  printf '%s\n' "$rotated"
} > "$layout_file"

i=0
printf '%s\n' "$rotated" | while IFS= read -r id; do
  [ -n "$id" ] || continue
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
    *) continue ;;
  esac

  yabai -m window "$id" --grid "$grid" >/dev/null 2>&1 || true
  i=$((i + 1))
done
