# 🌙 Minerva Rice

A dual-mode i3wm rice for Arch Linux featuring two distinct aesthetics that you can switch between instantly.

![Dual Rice Concept](https://img.shields.io/badge/i3wm-Dual%20Rice-ff007f?style=for-the-badge)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)

---

## 🎨 The Two Modes

### 🌸 Ethereal Mode
*Anime aesthetic, full immersion*

- **Theme**: Cyberpunk/vaporwave vibes with pink, cyan, and purple accents
- **Wallpaper**: Anime-style artwork
- **Compositor**: Full blur, transparency, and animations
- **Terminal**: Alacritty with 90% opacity
- **Widgets**: Conky system monitor, animated polybar
- **Gaps**: Generous spacing (15px inner, 5px outer)

### 🔒 Pentest Mode  
*High contrast, zero distractions*

- **Theme**: Void black with cyan accents
- **Wallpaper**: Minimal dark aesthetic
- **Compositor**: Basic picom, no fancy effects
- **Terminal**: Kitty (lightweight, fast)
- **Widgets**: Stripped-down polybar only
- **Gaps**: Minimal (6px inner, 0px outer)

---

## ⚡ Quick Start

### Prerequisites
- Fresh Arch Linux installation
- Network connection
- Non-root user with sudo

### Installation

```bash
git clone https://github.com/Expert21/Minerva-rice
cd Minerva-rice
chmod +x setup.sh
./setup.sh
```

Reboot when complete. You'll boot into the **Ethereal** mode by default.

---

## 🔄 Switching Modes

### Keybind (Recommended)
Press **`Super + Shift + M`** to toggle between modes instantly.

### Command Line
```bash
rice-switch ethereal   # Switch to anime aesthetic
rice-switch pentest    # Switch to distraction-free mode
```

---

## 📦 What's Included

### Core Stack
| Component | Package |
|-----------|---------|
| Window Manager | i3-wm |
| Status Bar | Polybar |
| Launcher | Rofi |
| Compositor | Picom (with animations) |
| Notifications | Dunst |
| Lock Screen | Betterlockscreen |

### Terminals
- **Alacritty** (Ethereal default) - GPU-accelerated, transparent
- **Kitty** (Pentest default) - Fast, lightweight

### File Managers
- **Thunar** - GUI file manager
- **Ranger** - Terminal file manager
- **Yazi** - Modern terminal file manager

### Extras
- **Conky** - System monitor widget (Ethereal only)
- **Cava** - Audio visualizer
- **Flameshot** - Screenshot tool
- **Nitrogen/Feh** - Wallpaper managers

---

## ⌨️ Keybindings

### Universal (Both Modes)
| Keybind | Action |
|---------|--------|
| `Super + Return` | Open terminal (Alacritty/Kitty) |
| `Super + D` | Open Rofi launcher |
| `Super + E` | Open File Manager (Ranger/Yazi) |
| `Super + Shift + F` | Toggle Fullscreen |
| `Super + Shift + Space` | Toggle Floating mode |
| `Super + Q` | Kill focused window |
| `Super + Shift + M` | Toggle rice mode (Ethereal/Pentest) |
| `Super + V` | Clipboard Manager (Greenclip) |
| `Super + Shift + X` | Lock screen |
| `Super + Arrows` | Change focus |
| `Super + Shift + Arrows` | Move windows |
| `Super + 1-5` | Switch workspace |
| `Super + Shift + 1-5` | Move window to workspace |
| `Print` | Screenshot (Flameshot) |

### System Controls
| Keybind | Action |
|---------|--------|
| `Super + Shift + C` | Reload i3 config |
| `Super + Shift + R` | Restart i3 in place |
| `Super + Shift + E` | Exit i3 (Logout) |
| `XF86Audio...` | Volume Control |
| `XF86MonBrightness...` | Brightness Control |

### Pentest Mode Extras
| Keybind | Action |
|---------|--------|
| `Super + B` | Open Firefox |

---

## 📁 Directory Structure

```
Minerva-rice/
├── setup.sh              # Master installer
├── rice-switch.sh        # Mode toggle script
├── configs/
│   ├── i3/               # i3 configs (ethereal + pentest)
│   ├── polybar/          # Bar configs + scripts
│   ├── rofi/             # Launcher themes
│   ├── picom/            # Compositor configs
│   ├── dunst/            # Notification configs
│   ├── kitty/            # Kitty terminal
│   ├── alacritty/        # Alacritty terminal
│   ├── conky/            # System widget
│   ├── gtk/              # GTK theming
│   └── ...
└── wallpapers/           # Mode wallpapers
```

---

## 🛠️ Customization

### Adding Your Own Wallpapers
Place wallpapers in `~/Pictures/Wallpapers/` and update `rice-switch.sh`:
```bash
nitrogen --set-zoom-fill ~/Pictures/Wallpapers/your-wallpaper.jpg --save &
```

### Modifying Colors
Each mode has its own color palette defined at the top of:
- `~/.config/i3/config` (border colors)
- `~/.config/polybar/config.ini` (bar colors)
- `~/.config/alacritty/alacritty.toml` (terminal colors)

### Creating a New Mode
1. Copy an existing config set (e.g., `config-ethereal` → `config-newmode`)
2. Customize colors, gaps, and autostart apps
3. Add a new case to `rice-switch.sh`
4. Add the keybind to your i3 configs

---

## 🔧 Troubleshooting

### No wallpaper after boot
Run manually: `nitrogen --restore` or `feh --bg-fill ~/Pictures/Wallpapers/your-wallpaper.jpg`

### Alacritty config error
Ensure the config is valid TOML format (Alacritty 0.12+ uses TOML, not YAML).

### emptty display manager not starting
Check service status:
```bash
sudo systemctl status emptty
```
Ensure the config exists at `/etc/emptty/conf` and the i3 session script at `/etc/emptty/i3`.

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🙏 Credits

- [i3wm](https://i3wm.org/)
- [Polybar](https://polybar.github.io/)
- [Picom](https://github.com/yshui/picom)
- [Rofi](https://github.com/davatorium/rofi)
- [Betterlockscreen](https://github.com/betterlockscreen/betterlockscreen)

---

<p align="center">
  <b>🌸 Ethereal</b> for creativity • <b>🔒 Pentest</b> for focus
</p>
