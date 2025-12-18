#!/bin/bash
# ╔═══════════════════════════════════════════════════════════╗
# ║  MINERVA RICE - MASTER SETUP (FRESH ARCH)                ║
# ║  Installs BOTH Pentest + Ethereal stacks                 ║
# ║  Stages mode configs (does NOT hard-write live configs)  ║
# ║  Defaults into: ETHEREAL                                 ║
# ╚═══════════════════════════════════════════════════════════╝

set -euo pipefail

# -------------------------
# SETTINGS
# -------------------------
DEFAULT_MODE="ethereal"   # ethereal | pentest
SET_XINITRC="true"        # true | false

# -------------------------
# COLORS
# -------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

say() { echo -e "${CYAN}$*${NC}"; }
ok()  { echo -e "${GREEN}✓${NC} $*"; }
warn(){ echo -e "${YELLOW}⚠${NC} $*"; }
die() { echo -e "${RED}❌${NC} $*"; exit 1; }

trap 'die "Install failed on line $LINENO. Fix the issue and re-run."' ERR

# -------------------------
# PRE-FLIGHT
# -------------------------
if [ "${EUID}" -eq 0 ]; then
  die "Don't run as root. Script uses sudo when needed."
fi
if [ ! -f /etc/arch-release ]; then
  die "Arch Linux only."
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -d "$SCRIPT_DIR/configs" ] || die "configs/ not found. Run from repo root."
[ -f "$SCRIPT_DIR/rice-switch.sh" ] || die "rice-switch.sh not found in repo root."

say "Running from: $SCRIPT_DIR"
say "Installing full Minerva stack (Pentest + Ethereal). Default: ${DEFAULT_MODE}"
echo

# -------------------------
# 1) SYSTEM UPDATE
# -------------------------
say "[1/10] Updating system..."
sudo pacman -Syu --noconfirm
ok "System updated"
echo

# -------------------------
# 2) CORE PACKAGES (PACMAN)
# -------------------------
say "[2/10] Installing core packages..."
sudo pacman -S --needed --noconfirm \
  base-devel git curl \
  xorg-server xorg-xinit xorg-xrandr xorg-xsetroot \
  i3-wm polybar rofi dunst \
  picom \
  feh \
  kitty alacritty \
  thunar ranger \
  flameshot \
  conky cava hyfetch fastfetch \
  lxsession lxappearance \
  xss-lock \
  networkmanager nm-connection-editor network-manager-applet \
  brightnessctl \
  polkit-gnome \
  xdg-utils \
  imagemagick \
  pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack \
  pavucontrol pamixer playerctl \
  zsh \
  qt5ct kvantum \
  nano nano-syntax-highlighting \
  ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts noto-fonts-emoji \
  papirus-icon-theme
ok "Core packages installed"
echo

# Optional: remove jack2 if present (avoids conflicts on some installs)
sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true

# -------------------------
# 3) YAZI + HELPERS
# -------------------------
say "[3/10] Installing Yazi + helpers..."
sudo pacman -S --needed --noconfirm \
  yazi ffmpegthumbnailer unarchiver jq poppler fd ripgrep fzf zoxide
ok "Yazi installed"
echo

# -------------------------
# 4) AUR (YAY + PACKAGES)
# -------------------------
say "[4/10] Installing AUR helper + AUR packages..."
if ! command -v yay >/dev/null 2>&1; then
  say "Installing yay..."
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
  ok "yay installed"
fi

# AUR packages your stack relies on
yay -S --needed --noconfirm \
  nitrogen \
  i3lock-color \
  xautolock \
  betterlockscreen \
  rofi-greenclip \
  picom-animations-git \
  arc-gtk-theme \
  emptty
ok "AUR packages installed"
echo

# -------------------------
# 5) ZSH (OH-MY-ZSH + PLUGINS + PURE)
# -------------------------
say "[5/10] Setting up Zsh ecosystem..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" 2>/dev/null || true

mkdir -p "$HOME/.zsh"
if [ ! -d "$HOME/.zsh/pure" ]; then
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
else
  (cd "$HOME/.zsh/pure" && git pull) || true
fi
ok "Zsh ecosystem ready"
echo

# -------------------------
# 6) DIRECTORY SCAFFOLDING
# -------------------------
say "[6/10] Creating directories..."
mkdir -p \
  "$HOME/.config"/{i3,polybar,rofi,dunst,picom,gtk-3.0,gtk-4.0,kitty,alacritty,cava,conky,ranger,hyfetch,yazi} \
  "$HOME/.config/ranger/colorschemes" \
  "$HOME/.local/bin" \
  "$HOME/Pictures"/{Wallpapers,Screenshots}
ok "Directories created"
echo

# -------------------------
# 7) STAGE CONFIGS (MODE FILES ONLY)
#     NOTE: We DO NOT write the "active" files directly here:
#     i3/config, picom/picom.conf, dunst/dunstrc, rofi/config.rasi, polybar/config.ini
#     Those are created by rice-switch via symlinks.
# -------------------------
say "[7/10] Staging configs..."

# i3
install -m 0644 "$SCRIPT_DIR/configs/i3/config-ethereal" "$HOME/.config/i3/config-ethereal"
install -m 0644 "$SCRIPT_DIR/configs/i3/config-pentest"  "$HOME/.config/i3/config-pentest"

# picom
install -m 0644 "$SCRIPT_DIR/configs/picom/picom-ethereal.conf" "$HOME/.config/picom/picom-ethereal.conf"
install -m 0644 "$SCRIPT_DIR/configs/picom/picom-pentest.conf"  "$HOME/.config/picom/picom-pentest.conf"

# dunst
install -m 0644 "$SCRIPT_DIR/configs/dunst/dunstrc-ethereal" "$HOME/.config/dunst/dunstrc-ethereal"
install -m 0644 "$SCRIPT_DIR/configs/dunst/dunstrc-pentest"  "$HOME/.config/dunst/dunstrc-pentest"

# rofi
install -m 0644 "$SCRIPT_DIR/configs/rofi/config-ethereal.rasi" "$HOME/.config/rofi/config-ethereal.rasi"
install -m 0644 "$SCRIPT_DIR/configs/rofi/config-pentest.rasi"  "$HOME/.config/rofi/config-pentest.rasi"

# polybar
install -m 0644 "$SCRIPT_DIR/configs/polybar/config-ethereal.ini" "$HOME/.config/polybar/config-ethereal.ini"
install -m 0644 "$SCRIPT_DIR/configs/polybar/config-pentest.ini"  "$HOME/.config/polybar/config-pentest.ini"
install -m 0755 "$SCRIPT_DIR/configs/polybar/launch.sh" "$HOME/.config/polybar/launch.sh"
# polybar scripts
if [ -d "$SCRIPT_DIR/configs/polybar/scripts" ]; then
  mkdir -p "$HOME/.config/polybar/scripts"
  cp -rf "$SCRIPT_DIR/configs/polybar/scripts/"* "$HOME/.config/polybar/scripts/"
  chmod +x "$HOME/.config/polybar/scripts/"*.sh 2>/dev/null || true
fi

# terminals
install -m 0644 "$SCRIPT_DIR/configs/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
install -m 0644 "$SCRIPT_DIR/configs/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# extras
install -m 0644 "$SCRIPT_DIR/configs/cava/config" "$HOME/.config/cava/config"
install -m 0644 "$SCRIPT_DIR/configs/conky/conky.conf" "$HOME/.config/conky/ethereal.conf"
install -m 0644 "$SCRIPT_DIR/configs/hyfetch/config.json" "$HOME/.config/hyfetch/config.json"
install -m 0644 "$SCRIPT_DIR/configs/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
install -m 0644 "$SCRIPT_DIR/configs/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# ranger + colorschemes folder if present
if [ -f "$SCRIPT_DIR/configs/ranger/rc.conf" ]; then
  install -m 0644 "$SCRIPT_DIR/configs/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
fi
if [ -d "$SCRIPT_DIR/configs/ranger/colorschemes" ]; then
  cp -rf "$SCRIPT_DIR/configs/ranger/colorschemes/." "$HOME/.config/ranger/colorschemes/"
fi

# GTK (mode files)
# gtk-3.0
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-3.0/settings-ethereal.ini" "$HOME/.config/gtk-3.0/settings-ethereal.ini"
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-3.0/settings-pentest.ini"  "$HOME/.config/gtk-3.0/settings-pentest.ini"
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-3.0/gtk-ethereal.css"      "$HOME/.config/gtk-3.0/gtk-ethereal.css"
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-3.0/gtk-pentest.css"       "$HOME/.config/gtk-3.0/gtk-pentest.css"

# gtk-4.0
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-4.0/settings-ethereal.ini" "$HOME/.config/gtk-4.0/settings-ethereal.ini"
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-4.0/settings-pentest.ini"  "$HOME/.config/gtk-4.0/settings-pentest.ini"
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-4.0/gtk-ethereal.css"      "$HOME/.config/gtk-4.0/gtk-ethereal.css"
install -m 0644 "$SCRIPT_DIR/configs/gtk/gtk-4.0/gtk-pentest.css"       "$HOME/.config/gtk-4.0/gtk-pentest.css"

# nano
install -m 0644 "$SCRIPT_DIR/configs/nano/.nanorc" "$HOME/.nanorc"

# zshrc (fresh-safe)
if [ ! -f "$HOME/.zshrc" ]; then
  install -m 0644 "$SCRIPT_DIR/configs/zsh/.zshrc" "$HOME/.zshrc"
else
  warn "~/.zshrc already exists; leaving untouched."
fi

ok "Configs staged"
echo

# -------------------------
# 8) WALLPAPERS + LOCKSCREEN IMAGE
# -------------------------
say "[8/10] Installing wallpapers..."
if [ -d "$SCRIPT_DIR/wallpapers" ] && [ "$(ls -A "$SCRIPT_DIR/wallpapers" 2>/dev/null)" ]; then
  cp -f "$SCRIPT_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/" || true
  ok "Wallpapers copied"
else
  warn "No wallpapers found in repo."
fi

# Set betterlockscreen image (prefer ethereal on fresh install)
if command -v betterlockscreen >/dev/null 2>&1; then
  if [ -f "$HOME/Pictures/Wallpapers/ethereal-wallpaper.jpeg" ]; then
    betterlockscreen -u "$HOME/Pictures/Wallpapers/ethereal-wallpaper.jpeg" || true
  else
    # fallback: first wallpaper found
    first_wp="$(ls -1 "$HOME/Pictures/Wallpapers" 2>/dev/null | head -n 1 || true)"
    if [ -n "${first_wp:-}" ]; then
      betterlockscreen -u "$HOME/Pictures/Wallpapers/$first_wp" || true
    fi
  fi
fi
echo

# -------------------------
# 9) SERVICES + ENV DEFAULTS
# -------------------------
say "[9/10] Enabling services + defaults..."
sudo systemctl enable --now NetworkManager >/dev/null 2>&1 || true
ok "NetworkManager enabled"

# Qt theming consistency
PROFILE_FILE="$HOME/.profile"
if ! grep -q "QT_QPA_PLATFORMTHEME=qt5ct" "$PROFILE_FILE" 2>/dev/null; then
  echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> "$PROFILE_FILE"
  ok "Added QT_QPA_PLATFORMTHEME=qt5ct to ~/.profile"
fi

# Default shell
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)" || true
  ok "Default shell set to zsh (applies next login)"
fi

# xinitrc
if [ "$SET_XINITRC" = "true" ]; then
  echo "exec i3" > "$HOME/.xinitrc"
  chmod +x "$HOME/.xinitrc"
  ok ".xinitrc written"
fi


# -------------------------
# EMPTTY DISPLAY MANAGER SETUP
# -------------------------
# Create emptty config directory
sudo mkdir -p /etc/emptty

# Copy config and MOTD (ASCII art) from rice
sudo cp "$SCRIPT_DIR/configs/emptty/conf" /etc/emptty/conf
sudo cp "$SCRIPT_DIR/configs/emptty/motd" /etc/emptty/motd

# Create i3 session script for emptty
sudo tee /etc/emptty/i3 >/dev/null <<'EOF'
#!/bin/sh
exec i3
EOF
sudo chmod +x /etc/emptty/i3

# Disable other display managers just in case
sudo systemctl disable ly 2>/dev/null || true
sudo systemctl disable lightdm 2>/dev/null || true
sudo systemctl disable sddm 2>/dev/null || true

# Enable emptty (don't start now - will activate on reboot)
sudo systemctl enable emptty
ok "emptty display manager configured"


# -------------------------
# 10) INSTALL rice-switch + SET DEFAULT MODE SYMLINKS
# -------------------------
say "[10/10] Installing rice-switch + setting default mode (${DEFAULT_MODE})..."
install -m 0755 "$SCRIPT_DIR/rice-switch.sh" "$HOME/.local/bin/rice-switch"

# Set up symlinks for default mode (without launching GUI apps)
# This avoids errors when running setup outside of X session
if [ "$DEFAULT_MODE" = "ethereal" ]; then
  ln -sf ~/.config/i3/config-ethereal ~/.config/i3/config
  ln -sf ~/.config/picom/picom-ethereal.conf ~/.config/picom/picom.conf
  ln -sf ~/.config/dunst/dunstrc-ethereal ~/.config/dunst/dunstrc
  ln -sf ~/.config/rofi/config-ethereal.rasi ~/.config/rofi/config.rasi
  ln -sf ~/.config/polybar/config-ethereal.ini ~/.config/polybar/config.ini
  ln -sf ~/.config/gtk-3.0/settings-ethereal.ini ~/.config/gtk-3.0/settings.ini
  ln -sf ~/.config/gtk-3.0/gtk-ethereal.css ~/.config/gtk-3.0/gtk.css
  ln -sf ~/.config/gtk-4.0/settings-ethereal.ini ~/.config/gtk-4.0/settings.ini
  ln -sf ~/.config/gtk-4.0/gtk-ethereal.css ~/.config/gtk-4.0/gtk.css
else
  ln -sf ~/.config/i3/config-pentest ~/.config/i3/config
  ln -sf ~/.config/picom/picom-pentest.conf ~/.config/picom/picom.conf
  ln -sf ~/.config/dunst/dunstrc-pentest ~/.config/dunst/dunstrc
  ln -sf ~/.config/rofi/config-pentest.rasi ~/.config/rofi/config.rasi
  ln -sf ~/.config/polybar/config-pentest.ini ~/.config/polybar/config.ini
  ln -sf ~/.config/gtk-3.0/settings-pentest.ini ~/.config/gtk-3.0/settings.ini
  ln -sf ~/.config/gtk-3.0/gtk-pentest.css ~/.config/gtk-3.0/gtk.css
  ln -sf ~/.config/gtk-4.0/settings-pentest.ini ~/.config/gtk-4.0/settings.ini
  ln -sf ~/.config/gtk-4.0/gtk-pentest.css ~/.config/gtk-4.0/gtk.css
fi
ok "Default mode set: ${DEFAULT_MODE}"

echo
echo -e "${GREEN}✅  INSTALLATION COMPLETE${NC}"
echo -e "${CYAN}Reboot and log in to start i3 with your rice!${NC}"
echo -e "${CYAN}Use:${NC}  rice-switch ethereal   |   rice-switch pentest"
echo
