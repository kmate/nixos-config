{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  security.pam.services.gtklock = {};

  environment.systemPackages = with pkgs; [
    gtklock
    gtklock-powerbar-module
  ];

  services = {
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          user = "km";
          command = "$SHELL -l";
        };
      };
    };
    udisks2.enable = true;
  };

  programs = {
    bash = {
      interactiveShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          WLR_NO_HARDWARE_CURSORS=1 Hyprland
        fi
      '';
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
    light.enable = true;
    dconf.enable = true;
    regreet.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*"; # TODO check: is this what I want/need?

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
}
