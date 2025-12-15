#!/bin/bash

MODE=$1  # First argument: "pentest" or "ethereal"

# --- HELPER FUNCTION FOR GTK ---
update_gtk() {
    THEME="$1"
    ICONS="$2"
    FONT="$3"
    CURSOR="$4"
    
    echo "[-] Updating GTK to: $THEME..."
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
    gsettings set org.gnome.desktop.interface icon-theme "$ICONS"
    gsettings set org.gnome.desktop.interface font-name "$FONT"
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR"
}

if [ "$MODE" == "pentest" ]; then
    # --- PENTEST MODE (Void Cyber) ---
    
    # 1. Symlink Shared Dotfiles (i3, picom, dunst, rofi, polybar)
    ln -sf ~/.config/i3/config-pentest ~/.config/i3/config
    ln -sf ~/.config/picom/picom-pentest.conf ~/.config/picom/picom.conf
    ln -sf ~/.config/dunst/dunstrc-pentest ~/.config/dunst/dunstrc
    ln -sf ~/.config/rofi/config-pentest.rasi ~/.config/rofi/config.rasi
    ln -sf ~/.config/polybar/config-pentest.ini ~/.config/polybar/config.ini

    # 2. Symlink GTK Configs
    ln -sf ~/.config/gtk-3.0/settings-pentest.ini ~/.config/gtk-3.0/settings.ini
    ln -sf ~/.config/gtk-3.0/gtk-pentest.css      ~/.config/gtk-3.0/gtk.css
    ln -sf ~/.config/gtk-4.0/settings-pentest.ini ~/.config/gtk-4.0/settings.ini
    ln -sf ~/.config/gtk-4.0/gtk-pentest.css      ~/.config/gtk-4.0/gtk.css
    
    # 3. Apply GTK Settings
    update_gtk "Arc-Dark" "Papirus-Dark" "JetBrainsMono Nerd Font 10" "Adwaita"
    
    # 4. Clean up Ethereal stuff
    killall conky 2>/dev/null
    
    # 5. Launch Bars & Wallpaper
    ~/.config/polybar/launch.sh
    feh --bg-fill ~/Pictures/Wallpapers/pentest-wallpaper.png & 
    
    notify-send "🔒 Pentest Mode Activated" "High contrast, zero distractions"
    
elif [ "$MODE" == "ethereal" ]; then
    # --- ETHEREAL MODE (Anime Aesthetic) ---
    
    # 1. Symlink Shared Dotfiles (i3, picom, dunst, rofi, polybar)
    ln -sf ~/.config/i3/config-ethereal ~/.config/i3/config
    ln -sf ~/.config/picom/picom-ethereal.conf ~/.config/picom/picom.conf
    ln -sf ~/.config/dunst/dunstrc-ethereal ~/.config/dunst/dunstrc
    ln -sf ~/.config/rofi/config-ethereal.rasi ~/.config/rofi/config.rasi
    ln -sf ~/.config/polybar/config-ethereal.ini ~/.config/polybar/config.ini

    # 2. Symlink GTK Configs
    ln -sf ~/.config/gtk-3.0/settings-ethereal.ini ~/.config/gtk-3.0/settings.ini
    ln -sf ~/.config/gtk-3.0/gtk-ethereal.css      ~/.config/gtk-3.0/gtk.css
    ln -sf ~/.config/gtk-4.0/settings-ethereal.ini ~/.config/gtk-4.0/settings.ini
    ln -sf ~/.config/gtk-4.0/gtk-ethereal.css      ~/.config/gtk-4.0/gtk.css
    
    # 3. Apply GTK Settings
    update_gtk "Adwaita-dark" "Papirus-Dark" "JetBrainsMono Nerd Font 11" "Adwaita"
    
    # 4. Launch Bars, Widgets & Wallpaper
    ~/.config/polybar/launch.sh
    nitrogen --restore & 
    conky -c ~/.config/conky/ethereal.conf &
    
    notify-send "🌸 Ethereal Mode Activated" "Anime aesthetic, full immersion"

else
    echo "Usage: rice-switch [pentest|ethereal]"
    exit 1
fi

# --- RELOAD EVERYTHING ---
i3-msg reload
i3-msg restart

killall picom
picom --config ~/.config/picom/picom.conf &

killall dunst
dunst &
