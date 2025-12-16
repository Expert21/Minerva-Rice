#!/bin/bash

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
BACKUP_DIR="$HOME/.config/minerva-backup-$(date +%Y%m%d-%H%M%S)"

echo "Starting configuration sync..."

# 1. Create Backup
echo "[-] Creating backup of existing configs at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

for folder in alacritty cava conky dunst gtk hyfetch i3 kitty nano picom polybar ranger rofi yazi zsh; do
    if [ -d "$CONFIG_DIR/$folder" ]; then
        cp -r "$CONFIG_DIR/$folder" "$BACKUP_DIR/"
    fi
done

# Backup scripts
if [ -f "$BIN_DIR/rice-switch" ]; then
    cp "$BIN_DIR/rice-switch" "$BACKUP_DIR/"
fi

echo "[+] Backup complete."

# 2. Copy Configs
echo "[-] Syncing configurations..."

# Create dirs if they don't exist
mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

# Copy config folders
cp -r "$REPO_DIR/configs/"* "$CONFIG_DIR/"

# Copy wallpapers
if [ -d "$REPO_DIR/wallpapers" ]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp "$REPO_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/"
fi

# 3. Copy Scripts
echo "[-] Installing scripts..."
cp "$REPO_DIR/rice-switch.sh" "$BIN_DIR/rice-switch"
chmod +x "$BIN_DIR/rice-switch"

# Ensure other scripts are executable
chmod +x "$CONFIG_DIR/polybar/launch.sh"
chmod +x "$CONFIG_DIR/polybar/scripts/"* 2>/dev/null

echo "=========================================="
echo " [SUCCESS] Configurations synced!"
echo "=========================================="
echo "Reload i3 (Mod+Shift+R) to apply changes."
