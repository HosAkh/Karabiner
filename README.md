# Karabiner and yabai setup

This repo contains the local keyboard and window-management setup for this Mac.

## What is configured

- `Caps Lock` acts as the hyper key: `command + control + option + shift`.
- `Hyper + Q` sends `Option + Shift + Left Arrow`.
- `Hyper + E` sends `Option + Shift + Right Arrow`.
- `Hyper + J/L/I/K` sends left/right/up/down arrows.
- `Hyper + '` sends `Fn + Delete`.
- `Hyper + M` toggles yabai focus-follows-mouse mode.
- Holding the hyper key shows `hyper` near the bottom center of the screen.
- Pressing `International 1` sends `Fn` and shows `FN` near the bottom center of the screen.
- yabai, skhd, and JankyBorders are installed/configured by `scripts/install_window_tools.sh`.

## Apply local config

```sh
./scripts/apply.sh
```

## Install window tools

```sh
./scripts/install_window_tools.sh
```

The install script needs Homebrew. If Homebrew itself is not installed yet, install it first from https://brew.sh and rerun the script.
