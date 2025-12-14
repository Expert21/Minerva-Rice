# Minerva Rice - Pentest Mode 🔒⚡

A minimal, high-contrast i3wm rice optimized for penetration testing and security work. Pure black (#000000) background with cyan (#00FFFF) accents for maximum focus and zero visual distraction.

## 🎯 Philosophy

This isn't a showcase rice - it's a **tool**. Built for long pentesting sessions where:
- High contrast reduces eye fatigue during 12+ hour engagements
- Zero animations = instant window switching for workflow speed
- No transparency (except terminal) = no accidental data leakage in screen shares
- Minimal visual noise = focus stays on terminal output

**This is "Pentest Mode"** - the first rice in a planned multi-mode distro system (Daily, Creative modes coming later).

## 🖥️ Stack

| Component | Tool |
|-----------|------|
| WM | i3-wm |
| Shell | Zsh + Oh-My-Zsh (Pure theme) |
| Terminal | Kitty |
| Compositor | picom |
| Launcher | Rofi |
| Bar | Polybar |
| Notifications | Dunst |
| Files | Yazi (CLI) + Thunar (GUI) |
| Screenshots | Flameshot |
| Wallpaper | Feh |
| Lock Screen | betterlockscreen |
| Audio | Pavucontrol + Pamixer |

## 🎨 Color Scheme

- **Background**: Pure Black (#000000)
- **Accent**: Cyan (#00FFFF)
- **Text**: White (#FFFFFF)
- **Inactive**: Grey (#666666)
- **Alert**: Red (#FF0000)

## 🚀 Installation

## Prerequisites
- Fresh Arch Linux installation
- Internet connection
- `git` installed

### Install
Fully automated - zero manual intervention:
```bash
git clone https://github.com/YourUsername/minerva-pentest
cd minerva-pentest
chmod +x setup.sh
./setup.sh
```


Choose manual install if you:
- Want to skip certain packages
- Already have some components configured
- Prefer granular control over the process

## ⌨️ Key Bindings

### Applications
- `Super + Enter` → Terminal (Kitty)
- `Super + D` → Launcher (Rofi)
- `Super + B` → Browser (Firefox)
- `Super + F` → File Manager (Yazi)

### Window Management
- `Super + Shift + Q` → Kill window
- `Super + J/K/L/;` → Focus window (Vim-style)
- `Super + Shift + J/K/L/;` → Move window
- `Super + F` → Fullscreen toggle
- `Super + Shift + Space` → Float toggle

### System
- `Super + Shift + C` → Reload i3 config
- `Super + Shift + R` → Restart i3
- `Super + Shift + E` → Exit i3
- `Super + Shift + X` → Lock screen

### Screenshots
- `Print` → Interactive screenshot (Flameshot GUI)
- `Shift + Print` → Full screen to clipboard

### Brightness (Laptops)
- `XF86MonBrightnessUp/Down` → Adjust brightness

## 🔒 Security Features

- **Auto-lock**: 10 minutes idle triggers lockscreen
- **Lock on suspend**: Automatic lock when laptop suspends
- **Notification privacy**: Dunst configured to not leak sensitive info
- **Clipboard manager**: Greenclip recommended (see setup script)

## 📁 Structure
```
~/.config/
├── i3/config
├── polybar/
│   ├── config.ini
│   └── launch.sh
├── rofi/config.rasi
├── kitty/kitty.conf
├── dunst/dunstrc
├── picom/picom.conf
└── yazi/
    ├── theme.toml
    └── yazi.toml
```

## 🎛️ Customization

### Change Accent Color
The cyan accent is defined in multiple config files:
- `~/.config/i3/config` → `set $accent-color #00ffff`
- `~/.config/polybar/config.ini` → `primary = #00FFFF`
- `~/.config/rofi/config.rasi` → `border-col: #00ffff;`
- `~/.config/kitty/kitty.conf` → `cursor #00ffff`
- `~/.config/dunst/dunstrc` → `frame_color = "#00ffff"`

Search and replace `#00ffff` / `#00FFFF` across all configs for consistent color changes.

### Adjust Opacity
Kitty terminal is set to 90% opacity. To change:
- Edit `~/.config/kitty/kitty.conf`
- Modify `background_opacity 0.90` (0.0 = transparent, 1.0 = opaque)

### Font Size
All configs use JetBrainsMono Nerd Font. Sizes are:
- i3: 10pt
- Polybar: 10pt
- Rofi: 11pt
- Kitty: 11pt
- Dunst: 10pt

## 🔧 Troubleshooting

### Qt apps look ugly
Run `qt5ct` and select your GTK theme. This forces Qt apps to match.

### Polybar not appearing
Check if `~/.config/polybar/launch.sh` is executable:
```bash
chmod +x ~/.config/polybar/launch.sh
```

#### Lockscreen wallpaper wrong
Re-run betterlockscreen setup:
```bash
betterlockscreen -u ~/Pictures/wallpaper.jpg
```

### No sound
Ensure PipeWire/PulseAudio is running:
```bash
systemctl --user status pipewire pipewire-pulse
```

## 🛠️ Future: Multi-Mode Rice Switching

This rice is "Pentest Mode" - designed for work. Future modes planned:
- **Daily Mode**: Warmer colors, transparency, web-focused
- **Creative Mode**: Larger fonts, writing-optimized, softer aesthetic

A `rice-switch.sh` script will symlink different config sets on the fly.

## 📜 Credits

- **Isaiah Myles** - Creator ([GitHub](https://github.com/YourUsername))
- Inspired by minimal tiling WM workflows and functional pentesting setups
- Built for security professionals who value focus over flash

## 📄 License

MIT License - See LICENSE file for details

---

**Remember**: This is a tool, not a toy. Built for long sessions, sharp focus, and getting work done.
