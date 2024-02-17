{...}: {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        user = "km";
        command = "$SHELL -l";
      };
    };
  };

  programs = {
    bash = {
      interactiveShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          WLR_NO_HARDWARE_CURSORS=1 Hyprland
        fi
      '';
    };
    light.enable = true;
    dconf.enable = true;
    regreet.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*"; # TODO check: is this what I want/need?
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
}
