{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./desktop
  ];

  home = {
    username = "km";
    homeDirectory = "/home/km";

    packages = let
      slack = pkgs.slack.overrideAttrs (old: {
        installPhase =
          old.installPhase
          + ''
            rm $out/bin/slack

            makeWrapper $out/lib/slack/slack $out/bin/slack \
              --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
              --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
              --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
          '';
      });
    in
      (with pkgs; [
        alejandra
        brave
        dive
        docker-compose
        graalvm-ce
        hunspell
        hunspellDicts.en_US
        hunspellDicts.hu_HU
        jetbrains.idea-community
        libreoffice-qt
        podman-tui
        sbt
        slack
        skypeforlinux
        transmission-qt
        visualvm
        vlc
        wine
        winetricks

        kitty
        dunst # TODO use mako?
        grim
        networkmanagerapplet
        slurp
        libappindicator-gtk3 # for udiskie
        wl-clipboard
        wlr-randr
        pamixer
        pavucontrol
        swww
        swayidle
        volantes-cursors
        wdisplays
      ])
      ++ (with pkgs.cinnamon; [
        nemo
      ])
      ++ (with pkgs.gnome; [
        gnome-keyring
      ]);

    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      EDITOR = "vim";
      BROWSER = "google-chrome";
      TERMINAL = "kitty";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };

    pointerCursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    stateVersion = "23.11";
  };

  xsession.preferStatusNotifierItems = true; # for udiskie

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    gnome-keyring = {
      enable = true;
      components = ["pkcs11" "secrets" "ssh"];
    };
    udiskie.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".swayidle" = let
    # TODO it cannot turn off the screen for some reason - permissions?
    #  the hyprctl command works when invoked directly from console
    swayidleConfig = pkgs.writeText ".swayidle" ''
      timeout 3000 'gtklock -i -m ${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so'
      timeout 6000 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
      before-sleep 'gtklock -i -m ${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so'
    '';
  in {
    source = swayidleConfig;
  };
}
