{...}: {
  home.file.".config/ghosty/config.toml".text = ''
    # General
    shell = "zsh"
    term = "xterm-256color"

    [appearance]
    font_family = "JetBrainsMono Nerd Font"
    font_size = 10.0
    font_style = "Regular"
    font_style_bold = "Bold"
    font_style_italic = "Italic"
    font_style_bold_italic = "Bold Italic"

    # Window appearance
    window_padding_x = 5
    window_padding_y = 5
    background_opacity = 0.9

    # Cursor
    cursor_style = "block"
    cursor_opacity = 1.0

    # Tab bar
    tab_bar_style = "compact"
    tab_bar_at_bottom = false

    [colors]
    background = "#1E1E2E"
    foreground = "#CDD6F4"
    cursor = "#F5E0DC"
    cursor_text = "#1E1E2E"
    selection_background = "#F5E0DC"
    selection_foreground = "#1E1E2E"

    # Palette colors
    palette_0 = "#45475A"    # black
    palette_1 = "#F38BA8"    # red
    palette_2 = "#A6E3A1"    # green
    palette_3 = "#F9E2AF"    # yellow
    palette_4 = "#89B4FA"    # blue
    palette_5 = "#F5C2E7"    # magenta
    palette_6 = "#94E2D5"    # cyan
    palette_7 = "#BAC2DE"    # white

    palette_8 = "#585B70"    # bright black
    palette_9 = "#F38BA8"    # bright red
    palette_10 = "#A6E3A1"   # bright green
    palette_11 = "#F9E2AF"   # bright yellow
    palette_12 = "#89B4FA"   # bright blue
    palette_13 = "#F5C2E7"   # bright magenta
    palette_14 = "#94E2D5"   # bright cyan
    palette_15 = "#A6ADC8"   # bright white

    [keybinds]
    # Split panes (iTerm2-like)
    # Vertical split (right)
    super+d = "create_window_right"
    # Horizontal split (bottom)
    super+shift+d = "create_window_below"

    # Navigate between panes
    super+left = "focus_left"
    super+right = "focus_right"
    super+up = "focus_up"
    super+down = "focus_down"

    # Resize panes
    super+cmd+left = "resize_window_left"
    super+cmd+right = "resize_window_right"
    super+cmd+up = "resize_window_up"
    super+cmd+down = "resize_window_down"

    # Zoom into a pane (maximize/toggle)
    super+cmd+enter = "toggle_window_zoom"

    # Close pane
    super+w = "close_window"

    # Clear terminal
    super+k = "clear_terminal"
  '';
}
