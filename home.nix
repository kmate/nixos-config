{
  lib,
  pkgs,
  ...
}: {
  imports = [
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
      # VLC starts on XWayland if DISPLAY is set (which we need to have for legacy apps)
      vlc = pkgs.symlinkJoin {
        name = "vlc";
        paths = [pkgs.vlc];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/vlc \
            --unset DISPLAY
          mv $out/share/applications/vlc.desktop{,.orig}
          substitute $out/share/applications/vlc.desktop{.orig,} \
            --replace-fail Exec=${pkgs.vlc}/bin/vlc Exec=$out/bin/vlc
        '';
      };
    in
      with pkgs; [
        alejandra
        brave
        dive
        docker-compose
        fastfetch
        file-roller
        font-manager
        gimp
        gnome-keyring
        graalvm-ce
        hunspell
        hunspellDicts.en_US
        hunspellDicts.hu_HU
        inkscape-with-extensions
        jetbrains.idea-community
        libreoffice-qt
        nemo
        ngrok
        nodejs
        p7zip
        podman-tui
        postman
        pwgen
        rclone
        sbt
        slack
        skypeforlinux
        transmission_4-gtk
        unrar
        unzip
        visualvm
        vlc
        wine
        winetricks

        hyprpicker
        kitty
        grim
        networkmanagerapplet
        slurp
        swappy
        libappindicator-gtk3 # for udiskie
        wl-clipboard
        wlr-randr
        pamixer
        pavucontrol
        volantes-cursors
        wdisplays
      ];

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
}
