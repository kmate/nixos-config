{pkgs, ...}: {
  # Override xdg-desktop-portal-hyprland with git master (post-v1.3.11)
  # Includes PR #379: DMA-BUF to SHM fallback + force_shm config option
  # Fixes: gnome-network-displays frozen frame due to buffer type mismatch
  # TODO: Remove this overlay once nixpkgs updates XDPH past v1.3.11
  nixpkgs.overlays = [
    (final: prev: {
      xdg-desktop-portal-hyprland = prev.xdg-desktop-portal-hyprland.overrideAttrs (oldAttrs: {
        version = "1.3.11-unstable-2026-03-15";
        src = final.fetchFromGitHub {
          owner = "hyprwm";
          repo = "xdg-desktop-portal-hyprland";
          rev = "a9b862d1aa000a676d310cc62d249f7ad726233d";
          hash = "sha256-2tJf/CQoHApoIudxHeJye+0Ii7scR0Yyi7pNiWk0Hn8=";
        };
        # Increase PipeWire SHM buffer pool from 4 to 16 (min 8).
        # XDPH runs out of buffers when gnome-network-displays' intervideosink
        # holds references, causing "Out of buffers" and frozen Miracast stream.
        patches = (oldAttrs.patches or []) ++ [
          ./patches/xdph-increase-shm-buffers.patch
        ];
      });

    })
  ];
  security.pam.services.hyprlock = {
    fprintAuth = true;
  };

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
    light.enable = true;
    dconf.enable = true;
    regreet.enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    # Route ScreenCast/Screenshot to XDPH, everything else to GTK portal
    # Don't enable wlr portal — it conflicts with XDPH for ScreenCast on Hyprland
    config = {
      common.default = ["gtk"];
      hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
        "org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
}
