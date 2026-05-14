#!/usr/bin/env sh
set -eu

PATH="$HOME/.local/bin:$PATH"
export PATH

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/karabiner-yabai"
pane_file="$state_dir/dual-pane"
dir="$(dirname "$0")"

if [ -f "$pane_file" ]; then
  exec "$dir/dual_pane_deactivate.sh"
else
  exec "$dir/dual_pane_activate.sh"
fi
