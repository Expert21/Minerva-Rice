#!/bin/bash

# ╔═══════════════════════════════════════════════════════════╗
# ║  MINERVA PENTEST MODE - AUTOMATED SETUP SCRIPT           ║
# ║  Pure i3 + Black/Cyan Rice for Security Work             ║
# ║  Zero prompts, zero bullshit, just install               ║
# ╚═══════════════════════════════════════════════════════════╝

set -e  # Exit on any error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║   ███╗   ███╗██╗███╗   ██╗███████╗██████╗ ██╗   ██╗ █████╗  
║   ████╗ ████║██║████╗  ██║██╔════╝██╔══██╗██║   ██║██╔══██╗ 
║   ██╔████╔██║██║██╔██╗ ██║█████╗  ██████╔╝██║   ██║███████║ 
║   ██║╚██╔╝██║██║██║╚██╗██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══██║ 
║   ██║ ╚═╝ ██║██║██║ ╚████║███████╗██║  ██║ ╚████╔╝ ██║  ██║ 
║   ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝ 
║                                                            ║
║              PENTEST MODE - AUTOMATED INSTALLER           ║
║              Black/Cyan - Zero Distractions               ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

sleep 1

# ============================================================
# PRE-FLIGHT CHECKS
# ============================================================

if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}❌ Don't run as root. Script will sudo when needed.${NC}"
    exit 1
fi

if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}❌ This script is for Arch Linux only.${NC}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -d "$SCRIPT_DIR/configs" ]; then
    echo -e "${RED}❌ Config directory not found!${NC}"
    echo "Run from the cloned repo:"
    echo "  git clone https://github.com/YourUsername/minerva-pentest"
    echo "  cd minerva-pentest"
    echo "  ./setup.sh"
    exit 1
fi

echo -e "${GREEN}✓${NC} Running from: $SCRIPT_DIR"
echo -e "${CYAN}Installing Minerva Pentest Mode...${NC}"
echo ""
sleep 1

# ============================================================
# SYSTEM UPDATE
# ============================================================

echo -e "${CYAN}[1/10] Updating system...${NC}"
sudo pacman -Syu --noconfirm
echo -e "${GREEN}✓${NC} System updated"
echo ""

# ============================================================
# INSTALL CORE PACKAGES
# ============================================================

echo -e "${CYAN}[2/10] Installing i3 ecosystem...${NC}"
sudo pacman -S --needed --noconfirm \
    i3-wm \
    i3lock \
    polybar \
    rofi \
    dunst \
    picom \
    feh \
    kitty \
    thunar \
    flameshot \
    xorg-server \
    xorg-xinit \
    xorg-xrandr \
    xorg-xsetroot \
    xss-lock \
    lxsession \
    lxappearance

echo -e "${GREEN}✓${NC} i3 ecosystem installed"

# ============================================================
# INSTALL FONTS
# ============================================================

echo -e "${CYAN}[3/10] Installing fonts...${NC}"
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji

echo -e "${GREEN}✓${NC} Fonts installed"

# ============================================================
# INSTALL THEMES & ICONS
# ============================================================

echo -e "${CYAN}[4/10] Installing themes...${NC}"
sudo pacman -S --needed --noconfirm \
    arc-gtk-theme \
    papirus-icon-theme \
    qt5ct \
    kvantum

echo -e "${GREEN}✓${NC} Themes installed"

# ============================================================
# INSTALL AUDIO
# ============================================================

echo -e "${CYAN}[5/10] Installing audio system...${NC}"
sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true
sudo pacman -S --needed --noconfirm \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    pavucontrol \
    pamixer

echo -e "${GREEN}✓${NC} Audio system installed"

# ============================================================
# INSTALL UTILITIES
# ============================================================

echo -e "${CYAN}[6/10] Installing system utilities...${NC}"
sudo pacman -S --needed --noconfirm \
    networkmanager \
    nm-connection-editor \
    network-manager-applet \
    brightnessctl \
    polkit-gnome \
    xdg-utils \
    imagemagick \
    nano-syntax-highlighting

echo -e "${GREEN}✓${NC} System utilities installed"

# ============================================================
# INSTALL SHELL & TOOLS
# ============================================================

echo -e "${CYAN}[7/10] Installing Zsh ecosystem...${NC}"

# Install Zsh
sudo pacman -S --needed --noconfirm zsh

# Install Oh-My-Zsh (non-interactive)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true

# Install Pure prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure" 2>/dev/null || (cd "$HOME/.zsh/pure" && git pull)

# Install fastfetch
sudo pacman -S --needed --noconfirm fastfetch

echo -e "${GREEN}✓${NC} Zsh ecosystem installed"

# ============================================================
# INSTALL YAZI
# ============================================================

echo -e "${CYAN}[8/10] Installing Yazi file manager...${NC}"
sudo pacman -S --needed --noconfirm yazi ffmpegthumbnailer unarchiver jq poppler fd ripgrep fzf zoxide imagemagick

echo -e "${GREEN}✓${NC} Yazi installed"

# ============================================================
# INSTALL AUR PACKAGES (BETTERLOCKSCREEN)
# ============================================================

echo -e "${CYAN}[9/10] Installing AUR packages...${NC}"

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
fi

# Install i3lock-color (required for betterlockscreen)
yay -S --needed --noconfirm i3lock-color

# Install xautolock
yay -S -needed --noconfirm xautolock

# Install betterlockscreen
yay -S --needed --noconfirm betterlockscreen

echo -e "${GREEN}✓${NC} AUR packages installed"

# ============================================================
# CREATE DIRECTORIES
# ============================================================

echo -e "${CYAN}[10/10] Setting up configurations...${NC}"

mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/kitty
mkdir -p ~/.config/dunst
mkdir -p ~/.config/picom
mkdir -p ~/.config/yazi
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/Pictures/Screenshots

echo -e "${GREEN}✓${NC} Directories created"

# ============================================================
# COPY CONFIG FILES
# ============================================================

# i3
cp -f "$SCRIPT_DIR/configs/i3/config" ~/.config/i3/config
echo -e "${GREEN}✓${NC} i3 config"

# Polybar
cp -f "$SCRIPT_DIR/configs/polybar/config.ini" ~/.config/polybar/config.ini
cp -f "$SCRIPT_DIR/configs/polybar/launch.sh" ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/launch.sh
echo -e "${GREEN}✓${NC} Polybar config"

# Rofi
cp -f "$SCRIPT_DIR/configs/rofi/config.rasi" ~/.config/rofi/config.rasi
echo -e "${GREEN}✓${NC} Rofi config"

# Kitty
cp -f "$SCRIPT_DIR/configs/kitty/kitty.conf" ~/.config/kitty/kitty.conf
echo -e "${GREEN}✓${NC} Kitty config"

# Dunst
cp -f "$SCRIPT_DIR/configs/dunst/dunstrc" ~/.config/dunst/dunstrc
echo -e "${GREEN}✓${NC} Dunst config"

# Picom
cp -f "$SCRIPT_DIR/configs/picom/picom.conf" ~/.config/picom/picom.conf
echo -e "${GREEN}✓${NC} Picom config"

# Yazi
cp -f "$SCRIPT_DIR/configs/yazi/theme.toml" ~/.config/yazi/theme.toml
cp -f "$SCRIPT_DIR/configs/yazi/yazi.toml" ~/.config/yazi/yazi.toml
echo -e "${GREEN}✓${NC} Yazi config"

# Zsh
cp -f "$SCRIPT_DIR/configs/zsh/.zshrc" ~/.zshrc
echo -e "${GREEN}✓${NC} Zsh config"

# GTK
cp -f "$SCRIPT_DIR/configs/gtk/gtk-3.0/settings.ini" ~/.config/gtk-3.0/settings.ini
cp -f "$SCRIPT_DIR/configs/gtk/gtk-4.0/settings.ini" ~/.config/gtk-4.0/settings.ini
echo -e "${GREEN}✓${NC} GTK config"

# Nano
cp -f "$SCRIPT_DIR/configs/nano/.nanorc" ~/.nanorc
echo -e "${GREEN}✓${NC} Nano config"

# ============================================================
# WALLPAPER SETUP
# ============================================================

if [ -d "$SCRIPT_DIR/wallpapers" ] && [ "$(ls -A $SCRIPT_DIR/wallpapers)" ]; then
    cp -f "$SCRIPT_DIR/wallpapers/"* ~/Pictures/Wallpapers/
    FIRST_WALLPAPER=$(ls ~/Pictures/Wallpapers/ | head -n 1)
    
    # Set betterlockscreen wallpaper
    betterlockscreen -u ~/Pictures/Wallpapers/$FIRST_WALLPAPER
    
    # Update i3 config with wallpaper path
    sed -i "s|exec_always --no-startup-id feh --bg-fill.*|exec_always --no-startup-id feh --bg-fill ~/Pictures/Wallpapers/$FIRST_WALLPAPER|" ~/.config/i3/config
    
    echo -e "${GREEN}✓${NC} Wallpaper configured"
else
    echo -e "${YELLOW}⚠${NC}  No wallpapers found - add to ~/Pictures/Wallpapers/"
fi

# ============================================================
# ENABLE SERVICES
# ============================================================

sudo systemctl enable --now NetworkManager
echo -e "${GREEN}✓${NC} NetworkManager enabled"

# ============================================================
# SET DEFAULT SHELL
# ============================================================

if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${CYAN}Changing default shell to Zsh...${NC}"
    chsh -s $(which zsh)
    echo -e "${GREEN}✓${NC} Default shell changed to Zsh"
fi

# ============================================================
# SETUP .XINITRC
# ============================================================

echo "exec i3" > ~/.xinitrc
chmod +x ~/.xinitrc
echo -e "${GREEN}✓${NC} .xinitrc configured"

# ============================================================
# FINAL SYSTEM CONFIG
# ============================================================

# Set GTK theme via gsettings (if available)
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null || true
fi

echo ""
echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅  INSTALLATION COMPLETE${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Minerva Pentest Mode is ready.${NC}"
echo ""
echo -e "${YELLOW}To start:${NC}"
echo "  1. Log out (or reboot)"
echo "  2. Run: ${GREEN}startx${NC}"
echo "  3. i3 will launch automatically"
echo ""
echo -e "${YELLOW}OR setup a display manager:${NC}"
echo "  ${GREEN}sudo pacman -S lightdm lightdm-gtk-greeter${NC}"
echo "  ${GREEN}sudo systemctl enable lightdm${NC}"
echo "  ${GREEN}sudo reboot${NC}"
echo ""
echo -e "${CYAN}Key bindings:${NC}"
echo "  ${GREEN}Super + Enter${NC}     → Terminal"
echo "  ${GREEN}Super + D${NC}         → Launcher"
echo "  ${GREEN}Super + Shift + Q${NC} → Kill window"
echo "  ${GREEN}Super + Shift + X${NC} → Lock screen"
echo "  ${GREEN}Print${NC}             → Screenshot"
echo ""
echo -e "${CYAN}Config locations:${NC}"
echo "  i3:      ${YELLOW}~/.config/i3/config${NC}"
echo "  Polybar: ${YELLOW}~/.config/polybar/config.ini${NC}"
echo "  Kitty:   ${YELLOW}~/.config/kitty/kitty.conf${NC}"
echo ""
echo -e "${GREEN}Stay sharp. 🔒⚡${NC}"
echo ""
