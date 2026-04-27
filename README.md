# Karabiner, yabai, and borders setup

This repo contains the local keyboard and window-management setup for this Mac.

## Current status

This repo stores and applies config. System tools still need to be installed on the Mac:

- Homebrew
- Karabiner-Elements
- yabai
- skhd
- JankyBorders (`borders`)

If active windows do not have a green outline, `borders` is either not installed, not running, or missing Accessibility permission.

## Shortcuts

- `Caps Lock` acts as the hyper key: `command + control + option + shift`.
- `International 1` acts as `Fn`.
- `Hyper + Q` selects one word left: `Option + Shift + Left Arrow`.
- `Hyper + E` selects one word right: `Option + Shift + Right Arrow`.
- `Hyper + J` sends `Left Arrow`.
- `Hyper + L` sends `Right Arrow`.
- `Hyper + I` sends `Up Arrow`.
- `Hyper + K` sends `Down Arrow`.
- `Hyper + '` sends `Fn + Delete`.
- `Hyper + M` toggles yabai focus-follows-mouse mode.

## On-screen overlays

- Holding the hyper key shows `hyper` near the bottom center of the screen.
- Pressing `International 1` sends `Fn` and shows `FN` near the bottom center of the screen.

## Window tools

- `yabai` manages tiled windows and supports window stacking.
- `skhd` provides yabai stack hotkeys.
- `borders` draws a green outline around the active window.

Stack controls in `skhd/skhdrc`:

- `Shift + Option + S`: stack focused window with window under mouse.
- `Shift + Option + X`: toggle split.
- `Shift + Option + H`: focus previous window in stack.
- `Shift + Option + L`: focus next window in stack.

## Files

- `karabiner/karabiner.json`: Karabiner keyboard mappings.
- `scripts/hyper_overlay.sh`: starts/stops overlay text.
- `scripts/HyperOverlay.m`: native macOS overlay app source.
- `scripts/toggle_yabai_mouse_focus.sh`: toggles yabai focus-follows-mouse.
- `yabai/yabairc`: yabai window-management config.
- `skhd/skhdrc`: stack-related yabai hotkeys.
- `borders/bordersrc`: green active-window border config.
- `scripts/start_borders.sh`: starts/restarts green active-window border.
- `scripts/install_window_tools.sh`: installs yabai, skhd, and borders with Homebrew.

## Apply local config

```sh
./scripts/apply.sh
```

This copies config into:

- `~/.config/karabiner/karabiner.json`
- `~/.config/yabai/yabairc`
- `~/.config/skhd/skhdrc`
- `~/.config/borders/bordersrc`

## Install window tools

```sh
./scripts/install_window_tools.sh
```

The install script needs Homebrew. If Homebrew itself is not installed yet, install it first from https://brew.sh and rerun the script.

## Start the green active-window outline

After `borders` is installed:

```sh
./scripts/start_borders.sh
```

Expected result: focused window has a bright green border. Unfocused windows have no visible border.

If nothing appears:

- Confirm `borders` exists: `command -v borders`
- Confirm it is running: `pgrep -fl borders`
- Grant Accessibility permission in System Settings to `borders`.
