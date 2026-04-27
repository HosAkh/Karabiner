#!/usr/bin/env sh
set -eu

if ! command -v borders >/dev/null 2>&1; then
  echo "borders is not installed. Run ./scripts/install_window_tools.sh first." >&2
  exit 1
fi

pkill -x borders >/dev/null 2>&1 || true

if [ -x "$HOME/.config/borders/bordersrc" ]; then
  "$HOME/.config/borders/bordersrc" &
else
  borders active_color=0xff00ff66 inactive_color=0x00000000 width=5.0 style=round hidpi=on &
fi
