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
    };
  };

  # Keybinds (iTerm2-like)
  xdg.configFile."ghostty/config".text = ''
    keybind = super+d=new_split:right
    keybind = super+shift+d=new_split:down
    keybind = super+left=goto_split:left
    keybind = super+right=goto_split:right
    keybind = super+up=goto_split:up
    keybind = super+down=goto_split:down
    keybind = super+cmd+enter=toggle_split_zoom
    keybind = super+w=close_surface
    keybind = super+k=clear_surface
  '';
}
