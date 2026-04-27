#!/usr/bin/env sh
set -eu

if command -v brew >/dev/null 2>&1; then
  brew_cmd=brew
elif [ -x /opt/homebrew/bin/brew ]; then
  brew_cmd=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
  brew_cmd=/usr/local/bin/brew
else
  echo "Homebrew is required. Install it from https://brew.sh, then rerun this script." >&2
  exit 1
fi

"$brew_cmd" install koekeishiya/formulae/yabai
"$brew_cmd" install koekeishiya/formulae/skhd
"$brew_cmd" install FelixKratz/formulae/borders

./scripts/apply.sh

yabai --start-service
skhd --start-service

./scripts/start_borders.sh

echo "Installed yabai, skhd, and borders."
echo "Grant Accessibility permissions to yabai, skhd, and Karabiner-Elements if macOS asks."
