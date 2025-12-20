#!/bin/bash

# Define paths
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"

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

echo "=========================================="
echo "      MINERVA RICE - RESTORE BACKUP       "
echo "=========================================="
echo

# 1. FIND BACKUPS
say "[1/4] Scanning for backups..."
# Find directories matching the pattern in .config
BACKUPS=($(find "$CONFIG_DIR" -maxdepth 1 -type d -name "minerva-backup-*" | sort -r))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    die "No backups found in $CONFIG_DIR."
fi

# 2. SELECT BACKUP
echo "Available backups:"
i=1
for backup in "${BACKUPS[@]}"; do
    name=$(basename "$backup")
    # Pretty print the timestamp part if possible, or just the name
    echo "  [$i] $name"
    ((i++))
done
echo

read -p "Select backup number to restore (1-${#BACKUPS[@]}): " selection

# Validate input
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#BACKUPS[@]}" ]; then
    die "Invalid selection."
fi

# Get selected path
SELECTED_BACKUP="${BACKUPS[$((selection-1))]}"
BACKUP_NAME=$(basename "$SELECTED_BACKUP")

echo
warn "WARNING: This will overwrite your current configuration with data from:"
warn "         $BACKUP_NAME"
read -p "Are you sure you want to proceed? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    die "Restore cancelled."
fi

# 3. RESTORE
say "[3/4] Restoring configurations..."

# Create necessary directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

# Iterate over items in the backup directory
for item in "$SELECTED_BACKUP"/*; do
    [ -e "$item" ] || continue
    base_name=$(basename "$item")
    
    if [ "$base_name" == "rice-switch" ]; then
        # Restore script
        say "  - Restoring script: $base_name"
        cp -f "$item" "$BIN_DIR/"
        chmod +x "$BIN_DIR/$base_name"
    elif [ -d "$item" ]; then
        # Restore config folder
        say "  - Restoring config: $base_name"
        # Remove existing config dir to ensure clean state (optional, but safer for consistency)
        rm -rf "$CONFIG_DIR/$base_name"
        cp -r "$item" "$CONFIG_DIR/"
    else
        # Handle loose files if any (e.g. if we backed up files directly to root of backup)
        say "  - Restoring file: $base_name"
        cp -f "$item" "$CONFIG_DIR/"
    fi
done

ok "Restore complete."
echo

# 4. RESTART I3
say "[4/4] Restarting i3..."
if pgrep -x "i3" > /dev/null; then
    i3-msg restart >/dev/null 2>&1 && ok "i3 restarted" || warn "Failed to restart i3."
else
    warn "i3 is not running. Changes will apply on next login."
fi

echo
echo "=========================================="
echo -e "${GREEN} [SUCCESS] System restored to: $BACKUP_NAME ${NC}"
echo "=========================================="
