# ==========================================================
#   RANGER COLORSCHEME - ETHEREAL
#   ~/.config/ranger/colorschemes/ethereal.py
# ==========================================================

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Ethereal(ColorScheme):
    progress_bar_color = magenta

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            # NEON SORCERY PALETTE
            # Pink: #FF007F
            # Cyan: #00D9FF
            # Gold: #FFB800
            # Purple: #BB00FF
            # Red: #FF3366
            # Green: #00FF9F
            # White: #E5E9F0
            # Dark: #0A0E27
            # Grey: #4C566A

            if context.selected:
                # Selected files - Hot Pink background
                attr = reverse
                fg = magenta
                attr |= bold

            if context.empty or context.error:
                # Empty directories or errors - Red
                fg = red

            if context.border:
                # Borders - Cyan
                fg = cyan

            if context.media:
                # Media files (images, videos) - Purple
                if context.image:
                    fg = magenta
                else:
                    fg = magenta

            if context.container:
                # Archives (.zip, .tar, etc) - Gold
                fg = yellow
                attr |= bold

            if context.directory:
                # Directories - Cyan (bold)
                fg = cyan
                attr |= bold

            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                # Executable files - Green
                fg = green
                attr |= bold

            if context.socket:
                # Sockets - Magenta
                fg = magenta
                attr |= bold

            if context.fifo or context.device:
                # Named pipes, devices - Yellow
                fg = yellow
                if context.device:
                    attr |= bold

            if context.link:
                # Symlinks - Cyan italic
                fg = cyan if context.good else red

            if context.tag_marker and not context.selected:
                # Tagged files - Gold
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = yellow

            if not context.selected and (context.cut or context.copied):
                # Cut/copied files - Grey dim
                fg = black
                attr |= bold

            if context.main_column:
                # Main column styling
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = yellow

            if context.badinfo:
                # Files with errors - Red
                if attr & reverse:
                    bg = red
                else:
                    fg = red

            if context.inactive_pane:
                # Inactive panes - Dim
                fg = cyan

        elif context.in_titlebar:
            # Title bar at top
            attr |= bold
            if context.hostname:
                # Hostname - Magenta
                fg = magenta
            elif context.directory:
                # Current directory - Cyan
                fg = cyan
            elif context.tab:
                # Tab titles
                if context.good:
                    # Active tab - Pink
                    fg = magenta
                    attr |= bold
                else:
                    # Inactive tab - Grey
                    fg = white
            elif context.link:
                # Links in title - Cyan
                fg = cyan

        elif context.in_statusbar:
            # Status bar at bottom
            if context.permissions:
                # Permission string - Purple
                if context.good:
                    fg = magenta
                elif context.bad:
                    fg = red

            if context.marked:
                # Marked items count - Gold
                attr |= bold | reverse
                fg = yellow

            if context.message:
                # Messages in statusbar
                if context.bad:
                    attr |= bold
                    fg = red
                else:
                    fg = cyan

            if context.loaded:
                # Loading indicator - Green
                fg = green

            if context.vcsinfo:
                # VCS info - Purple
                fg = magenta
                attr |= bold

            if context.vcscommit:
                # VCS commit - Green
                fg = green
                attr |= bold

        if context.text:
            # Regular text
            if context.highlight:
                # Search highlights - Gold on black
                attr |= reverse
                fg = yellow

        if context.in_taskview:
            # Task view (copy/move progress)
            if context.title:
                fg = magenta
                attr |= bold

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = green
                else:
                    fg = cyan

        return fg, bg, attr
