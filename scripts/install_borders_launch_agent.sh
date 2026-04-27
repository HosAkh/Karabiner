#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
agent_dir="$HOME/Library/LaunchAgents"
agent_plist="$agent_dir/com.karabiner.borders.plist"
domain="gui/$(id -u)"

if [ ! -x "$HOME/.local/bin/borders" ]; then
  echo "borders is not installed at $HOME/.local/bin/borders" >&2
  echo "Run ./scripts/install_borders_from_source.sh first." >&2
  exit 1
fi

mkdir -p "$agent_dir"
cp "$repo_dir/launch_agents/com.karabiner.borders.plist" "$agent_plist"

launchctl bootout "$domain" "$agent_plist" >/dev/null 2>&1 || true
launchctl bootstrap "$domain" "$agent_plist"
launchctl kickstart -k "$domain/com.karabiner.borders"

launchctl print "$domain/com.karabiner.borders" >/dev/null
