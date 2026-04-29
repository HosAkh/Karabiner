#!/usr/bin/env sh
set -eu

tmp_dir="${TMPDIR:-/tmp}/JankyBorders"
rm -rf "$tmp_dir"
git clone --depth 1 https://github.com/FelixKratz/JankyBorders.git "$tmp_dir"

make -C "$tmp_dir"

mkdir -p "$HOME/.local/bin"
cp "$tmp_dir/bin/borders" "$HOME/.local/bin/borders"

"$HOME/.local/bin/borders" --version
