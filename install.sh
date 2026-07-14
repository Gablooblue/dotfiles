#!/usr/bin/env bash
# Sets up AeroSpace + SketchyBar from this repo on a fresh (or existing) Mac.
# Idempotent: safe to re-run. Existing configs are backed up, never deleted.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '==> %s\n' "$*"; }

# 1. Install dependencies
if ! command -v brew >/dev/null 2>&1; then
  echo "ERROR: Homebrew is not installed. Install it first:" >&2
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' >&2
  exit 1
fi

# Newer Homebrew refuses third-party taps until explicitly trusted
if brew trust --help >/dev/null 2>&1; then
  log "Trusting third-party taps used by the Brewfile"
  brew trust --tap felixkratz/formulae nikitabobko/tap
fi

# A single failed cask must not block config symlinks below; warn and exit 1 at the end instead.
log "Installing dependencies from Brewfile (this can take a while on a fresh machine)"
BUNDLE_FAILED=0
brew bundle --file "$REPO_DIR/Brewfile" || BUNDLE_FAILED=1

# 2. Symlink configs. link <repo path> <target path>
link() {
  local src="$1" dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    log "OK: $dst already points to $src"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    log "Backing up existing $dst -> $bak"
    mv "$dst" "$bak"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  log "Linked $dst -> $src"
}

link "$REPO_DIR/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
link "$REPO_DIR/sketchybar" "$HOME/.config/sketchybar"

# 3. Start/reload services
log "Starting sketchybar service"
brew services restart sketchybar

if pgrep -x AeroSpace >/dev/null 2>&1; then
  log "Reloading AeroSpace config"
  if ! aerospace reload-config; then
    # Happens when brew bundle upgraded AeroSpace while the old version was running
    log "Reload failed; restarting AeroSpace to pick up the new version"
    osascript -e 'quit app "AeroSpace"' || true
    sleep 2
    open -a AeroSpace
  fi
else
  log "Starting AeroSpace"
  open -a AeroSpace
fi

if [ "$BUNDLE_FAILED" -eq 1 ]; then
  log "WARNING: some Brewfile dependencies failed to install (see errors above)."
  log "Casks like slack and zoom need sudo; re-run ./install.sh from an interactive terminal."
  exit 1
fi

log "Done. Workspace bar and tiling should be active."
