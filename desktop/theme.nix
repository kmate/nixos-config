{pkgs, ...}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Yaru-magenta-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Tokyonight-Dark-Compact";
      package = pkgs.tokyonight-gtk-theme.override {
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        themeVariants = ["default"];
      };
    };

    cursorTheme = {
      name = "volantes_cursors";
      package = pkgs.volantes-cursors;
    };
  };
}
