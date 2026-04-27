#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
history_file="$state_dir/focus-history"
mkdir -p "$state_dir"

window_id="${1:-}"
if [ -z "$window_id" ] && command -v yabai >/dev/null 2>&1; then
  window_id=$(yabai -m query --windows --window 2>/dev/null | jq -r '.id // empty' || true)
fi

case "$window_id" in
  ''|*[!0-9]*) exit 0 ;;
esac

tmp_file="$history_file.tmp"
{
  echo "$window_id"
  [ -f "$history_file" ] && grep -v "^$window_id$" "$history_file" || true
} | awk 'NF && !seen[$0]++ { print } NR >= 30 { exit }' > "$tmp_file"

mv "$tmp_file" "$history_file"
