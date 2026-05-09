# Local Setup Guide

This guide helps you work with this repository locally on your Mac.

## Repository Status

✅ **All files are pulled and ready for local work**

The repository contains:
- Karabiner keyboard configuration files
- yabai window management config
- skhd hotkey daemon config
- borders (JankyBorders) config
- Hammerspoon automation scripts
- Helper shell scripts for installation and management

## Quick Start

### 1. Clone the Repository

If you haven't already cloned this repository to your local machine:

```sh
git clone https://github.com/HosAkh/Karabiner.git
cd Karabiner
```

### 2. Pull Latest Changes

To ensure you have the latest version:

```sh
git fetch --all
git pull origin main
```

### 3. Apply Configuration

To apply the configuration files to your system:

```sh
./scripts/apply.sh
```

This will copy configuration files to:
- `~/.config/karabiner/karabiner.json`
- `~/.config/yabai/yabairc`
- `~/.config/skhd/skhdrc`
- `~/.config/borders/bordersrc`

### 4. Install Required Tools

If you haven't installed the system tools yet:

```sh
./scripts/install_window_tools.sh
```

This requires Homebrew. If Homebrew is not installed, visit https://brew.sh first.

The script installs:
- Karabiner-Elements (keyboard customization)
- yabai (window manager)
- skhd (hotkey daemon)
- borders (active window outline)

### 5. Start Borders

To enable the green outline around active windows:

```sh
./scripts/start_borders.sh
```

## Working with the Repository

### Making Changes

1. **Edit configuration files** in your preferred editor
2. **Test changes** by applying them: `./scripts/apply.sh`
3. **Restart services** if needed:
   - Karabiner: System Settings > Karabiner-Elements
   - yabai: `yabai --restart-service`
   - skhd: `skhd --restart-service`
   - borders: `./scripts/start_borders.sh`

### Configuration Files

- **`karabiner.json`**: Main Karabiner keyboard configuration (60KB)
- **`karabiner/karabiner.json`**: Alternative Karabiner config (28KB)
- **`yabai/yabairc`**: Window management rules and settings
- **`skhd/skhdrc`**: Hotkey bindings for window operations
- **`borders/bordersrc`**: Active window border styling
- **`hammerspoon/init.lua`**: Window stacking and automation logic

### Helper Scripts

Located in `scripts/`:
- **`apply.sh`**: Copy configs to system locations
- **`install_window_tools.sh`**: Install all dependencies via Homebrew
- **`start_borders.sh`**: Start/restart the window border overlay
- **`arrange_recent_windows.sh`**: Layout recent windows
- **`rotate_recent_layout.sh`**: Rotate window positions
- **`toggle_yabai_mouse_focus.sh`**: Toggle focus-follows-mouse
- **`toggle_yabai_tiling.sh`**: Toggle window tiling
- **`yabai_control.sh`**: Control yabai service
- **`open_app.sh`**: Launch apps from Karabiner layer

## Pushing Changes

After making and testing changes:

```sh
git add .
git commit -m "Description of changes"
git push origin main
```

## File Structure

```
.
├── README.md                  # Main documentation
├── LOCAL_SETUP.md            # This file
├── karabiner.json            # Main Karabiner config
├── karabiner/
│   └── karabiner.json        # Alternative Karabiner config
├── yabai/
│   └── yabairc               # yabai window manager config
├── skhd/
│   └── skhdrc                # Hotkey daemon config
├── borders/
│   └── bordersrc             # Window border config
├── hammerspoon/
│   └── init.lua              # Window automation scripts
├── scripts/                  # Helper scripts
└── launch_agents/            # LaunchAgent plists
```

## Troubleshooting

### Borders not showing

1. Check if borders is installed: `command -v borders`
2. Check if it's running: `pgrep -fl borders`
3. Restart: `./scripts/start_borders.sh`
4. Check macOS permissions for accessibility

### yabai not working

1. Disable System Integrity Protection (SIP) - see yabai docs
2. Restart yabai: `yabai --restart-service`
3. Check logs: `tail -f /tmp/yabai_*.out`

### Karabiner not responding

1. Open System Settings > Karabiner-Elements
2. Check if Input Monitoring permission is granted
3. Restart Karabiner-Elements

## Additional Resources

- [Karabiner-Elements Documentation](https://karabiner-elements.pqrs.org/docs/)
- [yabai Documentation](https://github.com/koekeishiya/yabai/wiki)
- [skhd Documentation](https://github.com/koekeishiya/skhd)
- [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- [Hammerspoon Documentation](https://www.hammerspoon.org/docs/)

---

**Ready to work!** All files have been pulled and are available locally in your cloned repository directory.
