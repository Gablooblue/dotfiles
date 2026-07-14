# dotfiles

AeroSpace (tiling WM) + SketchyBar (status bar) setup, portable to any Mac.

## New machine setup

```sh
# 1. Install Homebrew (if missing)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone and install
git clone git@github.com:Gablooblue/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

`install.sh` is idempotent: it installs everything in the `Brewfile` (AeroSpace, SketchyBar, JankyBorders, Hack Nerd Font, and all apps referenced by the window rules), backs up any existing configs to `*.bak.<timestamp>`, symlinks the configs from this repo, and starts the services.

## What's in here

| Repo path | Symlinked to | Purpose |
|---|---|---|
| `aerospace/aerospace.toml` | `~/.aerospace.toml` | i3-style tiling, keybinds, workspace rules |
| `sketchybar/` | `~/.config/sketchybar` | Bottom bar with AeroSpace workspace indicators |

Because the live configs are symlinks into this repo, any edit to them is immediately visible in `git status`. Commit and push to sync.

## Notes

- macOS will prompt for Accessibility permission for AeroSpace on first launch. Grant it in System Settings > Privacy & Security > Accessibility.
- App casks use `adopt: true`, so apps already installed manually are adopted by Homebrew instead of causing errors.
- Safari is referenced in the window rules but ships with macOS, so it is not in the Brewfile.
