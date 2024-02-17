{pkgs, ...}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Tokyonight-Dark-B-LB";
      package = pkgs.tokyo-night-gtk;
    };

    cursorTheme = {
      name = "Volantes";
      package = pkgs.volantes-cursors;
    };
  };
}
