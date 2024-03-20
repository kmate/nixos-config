{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    extraConfig = ''
      # Fix slow startup
      exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # Autostart
      ## System utilities
      exec-once = hyprctl setcursor volantes_cursors 32
      exec-once = dunst
      exec-once = swww init & sleep 0.5 && swww img ${./wallpaper.jpg}
      exec-once = swayidle -w -C ~/.swayidle
      ## Applications
      exec-once = kitty
      exec-once = google-chrome-stable
      exec-once = code
      exec-once = slack

      #source = /home/enzo/.config/hypr/colors
      exec = pkill waybar & sleep 0.5 && waybar

      # Input config
      input {
          kb_layout = us,hu
          kb_variant = ,101_qwerty_comma_nodead
          kb_model =
          kb_options = caps:escape
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = false
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      device:lenovo-thinkpad-laser-wireless-mouse {
        sensitivity = -0.5
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_invert = false
        workspace_swipe_fingers = 3
        workspace_swipe_distance = 500
        workspace_swipe_cancel_ratio = 0.5
        workspace_swipe_min_speed_to_force = 10
        workspace_swipe_create_new = true
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

      # Killing / closing things
      bind = $mainMod, Q, killactive

      windowrulev2 = workspace 1,class:(kitty)
      windowrulev2 = workspace 2,class:(google-chrome)
      windowrulev2 = workspace 3,class:(code-url-handler)
      windowrulev2 = workspace 4,class:(Slack)

      misc {
        disable_hyprland_logo = true
        key_press_enables_dpms = true
        mouse_move_enables_dpms = true
      }

      general {
        gaps_in = 2
        gaps_out = 2
        gaps_workspaces = 0

        resize_on_border = true
        extend_border_grab_area = 20
      }

      decoration {
        rounding = 2
        dim_inactive = true
      }
    '';
  };
}
