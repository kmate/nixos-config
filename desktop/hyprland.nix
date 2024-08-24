{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    extraConfig = ''
      # Fix slow startup
      exec = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # Change monitor to high resolution, the last argument is the scale factor
      monitor=,highres,auto,2

      # Unscale XWayland
      xwayland {
        force_zero_scaling = true
      }

      # Toolkit-specific scale
      env = GDK_SCALE,2
      env = QT_AUTO_SCREEN_SCALE_FACTOR,auto
      env = XCURSOR_SIZE,24

      # Autostart
      ## System utilities
      exec-once = hyprctl setcursor volantes_cursors 32

      ## Applications
      exec-once = kitty
      exec-once = google-chrome-stable --ozone-platform=wayland
      exec-once = code
      exec-once = slack
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

        sensitivity = 0
      }

      device {
        name = lenovo-thinkpad-laser-wireless-mouse
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
      bind = ALT SHIFT, RETURN, fullscreen
      bind = $mainMod, RETURN, exec, kitty
      bind = $mainMod, M, exit,
      bind = $mainMod, F, exec, nemo
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, anyrun

      # Switch to the next keyboard layout
      bind = $mainMod, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next

      # Screenshot
      bind = , Print, exec, grim -g "$(slurp -d)" - | swappy -f -

      # Color picker
      bind = $mainMod, C, exec, hyprpicker --autocopy
      bind = $mainMod SHIFT, C, exec, hyprpicker --autocopy --format=rgb

      # Functional keybinds
      bind =,XF86AudioMicMute,exec,pamixer --default-source -t
      bind =,XF86MonBrightnessDown,exec,light -U 20
      bind =,XF86MonBrightnessUp,exec,light -A 20
      bind =,XF86AudioMute,exec,pamixer -t
      bind =,XF86AudioLowerVolume,exec,pamixer -d 5
      bind =,XF86AudioRaiseVolume,exec,pamixer -i 5
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
      # Switch workspaces with mainMod + arrows
      bind = $mainMod SHIFT, right, workspace, +1
      bind = $mainMod SHIFT, left, workspace, -1

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
      # Move active window to a new empty workspace
      bind = $mainMod SHIFT, RETURN, movetoworkspace, empty

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Scroll through existing workspaces with side scroll
      bind = , mouse:276, workspace, e+1
      bind = , mouse:275, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      bindm = ALT, mouse:272, resizewindow

      # Killing / closing things
      bind = $mainMod, Q, killactive

      # Window rules
      windowrule = noblur,.*

      windowrulev2 = workspace 1,class:(kitty)
      windowrulev2 = workspace 2,class:(google-chrome)
      windowrulev2 = workspace 3,class:(code-url-handler)
      windowrulev2 = workspace 4,class:(Slack)

      # Dialogs
      windowrule = float,title:^(Open File)(.*)$
      windowrule = float,title:^(Open Folder)(.*)$
      windowrule = float,title:^(Select a File)(.*)$
      windowrule = float,title:^(Save As)(.*)$
      windowrule = float,title:^(Library)(.*)$
      windowrule = float,title:(Volume Control)
      windowrule = float,title:(Network Connections)
      windowrule = float,title:(.blueman-manager-wrapped)

      misc {
        disable_hyprland_logo = true
        key_press_enables_dpms = true
        mouse_move_enables_dpms = true
        vfr = true
      }

      general {
        gaps_in = 2
        gaps_out = 2
        gaps_workspaces = 0

        resize_on_border = true
        extend_border_grab_area = 20

        col.active_border = rgb(ae2077) rgb(db1f83) rgb(213477) rgb(1da2eb) 45deg
      }

      decoration {
        rounding = 2
        dim_inactive = false
        drop_shadow = false
      }
    '';
  };

  services = {
    dunst = {
      enable = true;

      # tries to mimic Tokyonight-Dark-B-LB
      settings = {
        global = {
          layout = "overlay";
          width = "(0, 300)";
          height = 100;
          offset = "5x5";

          font = "sans-serif 9";
          background = "#1F2231";
          foreground = "#C0CAF5";
          highlight = "#27A1B9";
          frame_color = "#27A1B9";
          frame_width = 2;
          separator_color = "#323648";
          separator_height = 1;
          horizontal_padding = 12;
          padding = 12;
          corner_radius = 12;
          markup = "full";
        };

        urgency_low = {
          frame_color = "#8166a0";
          highlight = "#8166a0";
          timeout = 10;
        };

        urgency_normal = {
          timeout = 15;
        };

        urgency_critical = {
          frame_color = "#d20065";
          highlight = "#d20065";
          timeout = 0;
        };
      };
    };

    hyprpaper = {
      enable = true;

      settings = {
        ipc = "off";
        splash = false;
        preload = ["${./wallpaper.jpg}"];
        wallpaper = [",${./wallpaper.jpg}"];
      };
    };

    hypridle = {
      enable = true;

      settings = {
        general = {
          # avoid starting multiple hyprlock instances
          lock_cmd = "pidof hyprlock || hyprlock";
          # lock before suspend
          before_sleep_cmd = "loginctl lock-session";
          # to avoid having to press a key twice to turn on the display
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          # dim monitor backlight after 2.5 mins
          {
            timeout = 150;
            on-timeout = "light -O && light -S 10";
            on-resume = "light -I";
          }
          # turn off keyboard backlight after 2.5 mins
          {
            timeout = 150;
            on-timeout = "light -s sysfs/leds/tpacpi::kbd_backlight -O && light -s sysfs/leds/tpacpi::kbd_backlight -S 0";
            on-resume = "light -s sysfs/leds/tpacpi::kbd_backlight -I";
          }
          # lock screen after 5 mins
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          # turn off display after 5.5 mins
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          # suspend after 10 mins
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };

  programs.hyprlock = {
    enable = true;

    # TODO customize look
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = true;
        grace = 5;
      };

      background = [
        {
          path = "${./wallpaper.jpg}";
        }
      ];

      label = [
        {
          text = "cmd[update:1000] date +%H:%M:%S";
          text_align = "center";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          #font_family = Noto Sans

          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          size = "300, 60";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(25, 134, 212)";
          inner_color = "rgb(22, 18, 41)";
          outer_color = "rgb(169, 52, 121)";
          outline_thickness = 1;
          placeholder_text = "";
          rounding = 2;
          shadow_passes = 0;
        }
      ];
    };
  };
}
