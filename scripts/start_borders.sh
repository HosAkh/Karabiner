#!/usr/bin/env sh
set -eu
PATH="$HOME/.local/bin:$PATH"
export PATH

if ! command -v borders >/dev/null 2>&1; then
  echo "borders is not installed. Run ./scripts/install_window_tools.sh first." >&2
  exit 1
fi

pkill -x borders >/dev/null 2>&1 || true
pkill -f "$HOME/.config/borders/bordersrc" >/dev/null 2>&1 || true

if [ -x "$HOME/.config/borders/bordersrc" ]; then
  nohup "$HOME/.config/borders/bordersrc" >/tmp/karabiner-borders.log 2>&1 &
else
  nohup borders active_color=0xff00ff66 inactive_color=0x00000000 width=5.0 style=round hidpi=on >/tmp/karabiner-borders.log 2>&1 &
fi
