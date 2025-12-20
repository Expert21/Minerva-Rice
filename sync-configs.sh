#!/bin/bash

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
BACKUP_DIR="$HOME/.config/minerva-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

say() { echo -e "${CYAN}$*${NC}"; }
ok()  { echo -e "${GREEN}✓${NC} $*"; }
warn(){ echo -e "${YELLOW}⚠${NC} $*"; }
die() { echo -e "${RED}❌${NC} $*"; exit 1; }

# Required Packages (Core + Yazi + AUR + Helpers)
REQUIRED_PACKAGES=(
  # Core
  "base-devel" "git" "curl"
  "xorg-server" "xorg-xinit" "xorg-xrandr" "xorg-xsetroot"
  "i3-wm" "polybar" "rofi" "dunst" "picom"
  "feh" "kitty" "alacritty"
  "thunar" "ranger" "flameshot"
  "conky" "cava" "fastfetch" "tmux"
  "lxsession" "lxappearance" "xss-lock"
  "networkmanager" "nm-connection-editor" "network-manager-applet"
  "brightnessctl" "polkit-gnome" "xdg-utils" "imagemagick"
  "pipewire" "wireplumber" "pipewire-pulse" "pipewire-alsa" "pipewire-jack"
  "pavucontrol" "pamixer" "playerctl"
  "zsh" "qt5ct" "kvantum"
  "nano" "nano-syntax-highlighting"
  "ttf-jetbrains-mono-nerd" "ttf-font-awesome" "noto-fonts" "noto-fonts-emoji"
  "papirus-icon-theme"
  
  # Yazi + Helpers
  "yazi" "ffmpegthumbnailer" "unarchiver" "jq" "poppler" "fd" "ripgrep" "fzf" "zoxide"
  
  # AUR (Note: Script will try yay for these)
  "nitrogen" "i3lock-color" "xautolock" "betterlockscreen"
  "rofi-greenclip" "picom-animations-git" "arc-gtk-theme" "emptty"
)

# -------------------------
# HELPER FUNCTIONS
# -------------------------
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

smart_install() {
    local pkg="$1"
    if is_installed "$pkg"; then
        return 0
    fi
    
    # Try pacman first
    if pacman -Si "$pkg" &>/dev/null;
 then
        echo -e "Installing $pkg via pacman..."
        sudo pacman -S --needed --noconfirm "$pkg"
        return 0
    fi
    
    # Fall back to yay
    if command -v yay &>/dev/null;
 then
        echo -e "Installing $pkg via yay (AUR)..."
        yay -S --needed --noconfirm "$pkg"
        return 0
    fi
    
    warn "Could not install $pkg (not found in pacman or yay)"
    return 1
}

# -------------------------
# 1. CHECK SOFTWARE
# -------------------------
say "Starting configuration sync..."
echo

say "[1/5] Checking for required software..."
MISSING_PACKAGES=()

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! is_installed "$pkg"; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    warn "The following packages are missing:"
    printf "  - %s\n" "${MISSING_PACKAGES[@]}"
    echo
    read -p "Do you want to attempt to install them now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Ensure yay is present if needed
        if ! command -v yay >/dev/null 2>&1; then
             say "yay not found. Installing yay first..."
             sudo pacman -S --needed --noconfirm base-devel git
             tmpdir="$(mktemp -d)"
             git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
             (cd "$tmpdir/yay" && makepkg -si --noconfirm)
             rm -rf "$tmpdir"
        fi

        for pkg in "${MISSING_PACKAGES[@]}"; do
            smart_install "$pkg"
        done
        ok "Installation attempt complete."
    else
        warn "Skipping installation. Some features may not work."
    fi
else
    ok "All required packages are installed."
fi
echo

# -------------------------
# 2. BACKUP
# -------------------------
say "[2/5] Creating backup of existing configs at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Backup standard folders
for folder in alacritty cava conky dunst gtk hyfetch i3 kitty nano picom polybar ranger rofi yazi zsh fastfetch; do
    if [ -d "$CONFIG_DIR/$folder" ]; then
        cp -r "$CONFIG_DIR/$folder" "$BACKUP_DIR/"
    fi
done

# Backup scripts
if [ -f "$BIN_DIR/rice-switch" ]; then
    cp "$BIN_DIR/rice-switch" "$BACKUP_DIR/"
fi
ok "Backup complete."
echo

# -------------------------
# 3. SYNC CONFIGS
# -------------------------
say "[3/5] Syncing configurations..."

# Create dirs if they don't exist
mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$HOME/Pictures/Wallpapers"

# Copy config folders (including fastfetch which is now in configs/fastfetch)
cp -r "$REPO_DIR/configs/"* "$CONFIG_DIR/"

# Copy wallpapers
if [ -d "$REPO_DIR/wallpapers" ]; then
    cp -f "$REPO_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/"
fi
ok "Configs synced."
echo

# -------------------------
# 4. INSTALL SCRIPTS
# -------------------------
say "[4/5] Updating scripts..."
cp "$REPO_DIR/rice-switch.sh" "$BIN_DIR/rice-switch"
chmod +x "$BIN_DIR/rice-switch"

# Ensure other scripts are executable
chmod +x "$CONFIG_DIR/polybar/launch.sh" 2>/dev/null || true
if [ -d "$CONFIG_DIR/polybar/scripts" ]; then
    chmod +x "$CONFIG_DIR/polybar/scripts/"* 2>/dev/null || true
fi
ok "Scripts updated."
echo

# -------------------------
# 5. RESTART I3
# -------------------------
say "[5/5] Restarting i3..."
if pgrep -x "i3" > /dev/null;
then
    i3-msg restart >/dev/null 2>&1 && ok "i3 restarted" || warn "Failed to restart i3 (is it running?)"
else
    warn "i3 is not running. Changes will apply on next login."
fi

echo
echo "==========================================