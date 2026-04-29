#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PATH="$HOME/.local/bin:$PATH"
export PATH

mkdir -p "$HOME/.config/karabiner" "$HOME/.config/yabai" "$HOME/.config/skhd" "$HOME/.config/borders"

cp "$repo_dir/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
cp "$repo_dir/yabai/yabairc" "$HOME/.config/yabai/yabairc"
cp "$repo_dir/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
cp "$repo_dir/borders/bordersrc" "$HOME/.config/borders/bordersrc"

chmod +x "$HOME/.config/yabai/yabairc"
chmod +x "$HOME/.config/borders/bordersrc"
chmod +x "$repo_dir/scripts/"*.sh

if command -v karabiner_cli >/dev/null 2>&1; then
  karabiner_cli --reloadxml >/dev/null 2>&1 || true
fi

if command -v yabai >/dev/null 2>&1; then
  yabai --restart-service >/dev/null 2>&1 || true
fi

if command -v skhd >/dev/null 2>&1; then
  skhd --restart-service >/dev/null 2>&1 || true
fi

if command -v borders >/dev/null 2>&1; then
  "$repo_dir/scripts/start_borders.sh" >/dev/null 2>&1 || true
fi
