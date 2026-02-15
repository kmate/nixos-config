{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    settings = {
      # Shell
      command = ["${pkgs.zsh}/bin/zsh"];

      # Appearance
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10;
      font-style = "Regular";
      font-style-bold = "Bold";
      font-style-italic = "Italic";
      font-style-bold-italic = "Bold Italic";

      # Window appearance
      window-padding-x = 5;
      window-padding-y = 5;
      background-opacity = 0.9;
      
      # Splits
      unfocused-split-opacity = 0.5;

      # Behavior
      quit-after-last-window-closed = true;
      confirm-close-surface = false;
      copy-on-select = true;

      # Cursor
      cursor-style = "block";
      cursor-opacity = 1.0;

      # Colors
      background = "#1E1E2E";
      foreground = "#CDD6F4";
      selection-background = "#F5E0DC";
      selection-foreground = "#1E1E2E";

      # Palette
      palette = [
        "0=#45475A"
        "1=#F38BA8"
        "2=#A6E3A1"
        "3=#F9E2AF"
        "4=#89B4FA"
        "5=#F5C2E7"
        "6=#94E2D5"
        "7=#BAC2DE"
        "8=#585B70"
        "9=#F38BA8"
        "10=#A6E3A1"
        "11=#F9E2AF"
        "12=#89B4FA"
        "13=#F5C2E7"
        "14=#94E2D5"
        "15=#A6ADC8"
      ];

      # Keybinds (iTerm2-like)
      keybind = [
        # Ignore arrow key combinations to prevent unwanted sequences
        "ctrl+shift+alt+left=ignore"
        "ctrl+shift+alt+right=ignore"
        "ctrl+shift+alt+up=ignore"
        "ctrl+shift+alt+down=ignore"
        "super+shift+left=ignore"
        "super+shift+right=ignore"
        "super+shift+up=ignore"
        "super+shift+down=ignore"
        "super+alt+left=ignore"
        "super+alt+right=ignore"
        "super+alt+up=ignore"
        "super+alt+down=ignore"
        "ctrl+alt+left=ignore"
        "ctrl+alt+right=ignore"
        "ctrl+alt+up=ignore"
        "ctrl+alt+down=ignore"
        "alt+left=ignore"
        "alt+right=ignore"
        "alt+up=ignore"
        "alt+down=ignore"
        
        # Split creation
        "super+d=new_split:right"
        "super+shift+d=new_split:down"
        
        # Split navigation
        "super+ctrl+left=goto_split:left"
        "super+ctrl+right=goto_split:right"
        "super+ctrl+up=goto_split:up"
        "super+ctrl+down=goto_split:down"
        
        # Split resizing
        "super+ctrl+shift+left=resize_split:left,10"
        "super+ctrl+shift+right=resize_split:right,10"
        "super+ctrl+shift+up=resize_split:up,10"
        "super+ctrl+shift+down=resize_split:down,10"
        
        # Other
        "super+ctrl+enter=toggle_split_zoom"
        "super+ctrl+q=close_surface"
        "super+k=clear_screen"
      ];
    };
  };
}
