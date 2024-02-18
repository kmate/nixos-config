{
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

    packages =
      (with pkgs; [
        alejandra
        btop
        jq
        silver-searcher
        slack
        wine
        winetricks

        kitty
        dunst # TODO use mako?
        grim
        slurp
        wl-clipboard
        wlr-randr
        pamixer
        waybar
        swww
        volantes-cursors
      ])
      ++ (with pkgs.cinnamon; [
        nemo
      ]);

    sessionVariables = {
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

    # The state version is required and should stay at the version you
    # originally installed.
    stateVersion = "23.11";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "kmate";
      userEmail = "mtkarc@gmail.com";
      aliases = {
        br = "branch";
        ci = "commit";
        co = "checkout";
        st = "status";
      };
      extraConfig = {
        credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret";
      };
    };

    vscode.enable = true;
  };

  # TODO cursor size!!
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      # Monitor
      # monitor=DP-1,1920x1080@165,auto,1

      # Fix slow startup
      exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # Autostart
      exec-once = hyprctl setcursor volantes_cursors 32
      exec-once = dunst

      #source = /home/enzo/.config/hypr/colors
      exec = pkill waybar & sleep 0.5 && waybar
      exec-once = swww init & sleep 0.5 && swww img ${./desktop/wallpaper.jpg}
      # exec-once = wallpaper_random

      # Set en layout at startup

      # Input config
      input {
          kb_layout = us,hu
          kb_variant =
          kb_model =
          kb_options = caps:escape
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = false
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      $mainMod = SUPER
      bind = $mainMod, G, fullscreen,
      bind = $mainMod, RETURN, exec, kitty
      bind = $mainMod, M, exit,
      bind = $mainMod, F, exec, nemo
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, anyrun
      # check hyprctl devices to get device name for keyboard
      bind = $mainMod, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next

      # Screenshot
      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = SHIFT, Print, exec, grim -g "$(slurp)"

      # Functional keybinds
      bind =,XF86AudioMicMute,exec,pamixer --default-source -t
      bind =,XF86MonBrightnessDown,exec,light -U 20
      bind =,XF86MonBrightnessUp,exec,light -A 20
      bind =,XF86AudioMute,exec,pamixer -t
      bind =,XF86AudioLowerVolume,exec,pamixer -d 10
      bind =,XF86AudioRaiseVolume,exec,pamixer -i 10
      bind =,XF86AudioPlay,exec,playerctl play-pause
      bind =,XF86AudioPause,exec,playerctl play-pause

      # to switch between windows in a floating workspace
      bind = SUPER,Tab,cyclenext,
      bind = SUPER,Tab,bringactivetotop,

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      bindm = ALT, mouse:272, resizewindow

      misc {
        disable_hyprland_logo = true
      }
    '';
  };
}
