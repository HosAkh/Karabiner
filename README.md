# Karabiner, yabai, and borders setup

This repo contains the local keyboard and window-management setup for this Mac.

## Current status

This repo stores and applies config. System tools still need to be installed on the Mac:

- Homebrew
- Karabiner-Elements
- yabai
- skhd
- JankyBorders (`borders`)

If active windows do not have a green outline, `borders` is either not installed, not running, or macOS is blocking the overlay from drawing.

This machine also supports a user-local `borders` install at `~/.local/bin/borders` when Homebrew is not available.

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
- `Hyper + 2` lays out the current active window and previous active window side by side.
- `Hyper + 3` lays out the current active window and two previous active windows in three columns.
- `Hyper + 4` lays out the current active window and three previous active windows in a 2x2 grid.
- `Hyper + R` rotates window positions inside the last `Hyper + 2/3/4` layout.
- `Hyper + A` enters the app launcher layer.

App launcher layer after pressing `Hyper + A`:

- `D`: open Dia.
- `M`: open Messages.
- `W`: open WhatsApp.
- `S`: open Slack.
- `C`: open Codex.
- `Escape`: leave the layer without opening an app.

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
- `scripts/track_yabai_focus.sh`: records recent yabai window focus history.
- `scripts/arrange_recent_windows.sh`: lays out the most recently focused windows.
- `scripts/rotate_recent_layout.sh`: rotates the last recent-window layout.
- `scripts/open_app.sh`: opens apps from the Karabiner app launcher layer.
- `yabai/yabairc`: yabai window-management config.
- `skhd/skhdrc`: stack-related yabai hotkeys.
- `borders/bordersrc`: green active-window border config.
- `scripts/start_borders.sh`: starts/restarts green active-window border.
- `launch_agents/com.karabiner.borders.plist`: user LaunchAgent that keeps `borders` running.
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

If Homebrew is not available, install `borders` from source:

```sh
./scripts/install_borders_from_source.sh
```

After `borders` is installed:

```sh
./scripts/start_borders.sh
```

Expected result: focused window has a bright green border. Unfocused windows have no visible border.

`scripts/start_borders.sh` installs `launch_agents/com.karabiner.borders.plist` into `~/Library/LaunchAgents` so macOS keeps the border process alive.

If nothing appears:

- Confirm `borders` exists: `command -v borders`
- Confirm it is running: `pgrep -fl borders`
- Restart `borders`: `./scripts/start_borders.sh`
