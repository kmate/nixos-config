{pkgs, ...}: let
  new-terminal = pkgs.writeShellApplication {
    name = "new-terminal";
    runtimeInputs = [pkgs.hyprland pkgs.jq pkgs.ghostty pkgs.wtype];
    text = builtins.readFile ./new-terminal.sh;
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";

    extraConfig = ''
      -- Startup
      hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("hyprctl setcursor volantes_cursors 32")
        hl.exec_cmd("ghostty")
        hl.exec_cmd("google-chrome-stable --ozone-platform=wayland")
        hl.exec_cmd("code")
        hl.exec_cmd("slack")
        hl.exec_cmd("pkill waybar; sleep 0.5; waybar")
      end)

      -- Change monitor to high resolution, the last argument is the scale factor
      hl.monitor({ output = "", mode = "highres", position = "auto", scale = 2 })

      -- Toolkit-specific scale
      hl.env("GDK_SCALE", "2")
      hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "auto")
      hl.env("XCURSOR_SIZE", "24")

      -- Input config
      hl.config({
        input = {
          kb_layout = "us,hu",
          kb_variant = ",101_qwerty_comma_nodead",
          kb_options = "caps:escape",
          follow_mouse = 1,
          touchpad = {
            natural_scroll = false,
          },
          sensitivity = 0,
        },
        xwayland = {
          force_zero_scaling = true,
        },
        gestures = {
          workspace_swipe_invert = false,
          workspace_swipe_distance = 500,
          workspace_swipe_cancel_ratio = 0.5,
          workspace_swipe_min_speed_to_force = 10,
          workspace_swipe_create_new = true,
        },
        misc = {
          disable_hyprland_logo = true,
          key_press_enables_dpms = true,
          mouse_move_enables_dpms = true,
        },
        general = {
          gaps_in = 2,
          gaps_out = 2,
          gaps_workspaces = 0,
          resize_on_border = true,
          extend_border_grab_area = 20,
          ["col.active_border"] = {
            colors = { "rgb(ae2077)", "rgb(db1f83)", "rgb(213477)", "rgb(1da2eb)" },
            angle = 45
          }
        },
        decoration = {
          rounding = 2,
          dim_inactive = false,
        },
      })

      hl.device({
        name = "lenovo-thinkpad-laser-wireless-mouse",
        sensitivity = -0.5,
      })

      hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace",
      })

      -- Binds
      local mainMod = "SUPER"
      hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen())
      hl.bind("ALT + SHIFT + RETURN", hl.dsp.window.fullscreen())
      hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("${new-terminal}/bin/new-terminal"))
      hl.bind(mainMod .. " + M", hl.dsp.exit())
      hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("nemo"))
      hl.bind(mainMod .. " + V", hl.dsp.window.float())
      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("anyrun"))

      -- Switch to the next keyboard layout
      hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next"))

      -- Screenshot
      hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | swappy -f -'))

      -- Color picker
      hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))
      hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy --format=rgb"))

      -- Functional keybinds
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"))
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"))
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))

      -- Switch between windows in a floating workspace
      hl.bind("SUPER + Tab", hl.dsp.window.cycle_next())
      hl.bind("SUPER + Tab", hl.dsp.window.bring_to_top())

      -- TODO: fix movefocus dispatcher (hl.dsp.focus exists but args unknown)
      -- hl.bind(mainMod .. " + left", hl.dsp.window.focus({ direction = "left" }))
      -- hl.bind(mainMod .. " + right", hl.dsp.window.focus({ direction = "right" }))
      -- hl.bind(mainMod .. " + up", hl.dsp.window.focus({ direction = "up" }))
      -- hl.bind(mainMod .. " + down", hl.dsp.window.focus({ direction = "down" }))

      -- Loop to create bindings for workspaces 1 through 9
      for i = 1, 9 do
          -- Switch to workspace (SUPER + [1-9])
          hl.bind(mainMod .. " + " .. i, function()
              hl.dispatch(hl.dsp.focus({ workspace = tostring(i) }))
          end)

          -- Move active window to workspace silently (SUPER + SHIFT + [1-9])
          hl.bind(mainMod .. " + SHIFT + " .. i, function()
              hl.dispatch(hl.dsp.window.move({ workspace = tostring(i), silent = true }))
          end)
      end

      -- TODO
      -- hl.bind(mainMod .. " + 0", hl.dsp.workspace(10))
      -- hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
      -- hl.bind(mainMod .. " + SHIFT + right", hl.dsp.workspace({ relative = 1 }))
      -- hl.bind(mainMod .. " + SHIFT + left", hl.dsp.workspace({ relative = -1 }))
      -- hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.window.move({ workspace = "empty" }))
      -- hl.bind(mainMod .. " + mouse_down", hl.dsp.workspace({ relative = 1 }), { mouse = true })
      -- hl.bind(mainMod .. " + mouse_up", hl.dsp.workspace({ relative = -1 }), { mouse = true })
      -- hl.bind("mouse:276", hl.dsp.workspace({ relative = 1 }), { mouse = true })
      -- hl.bind("mouse:275", hl.dsp.workspace({ relative = -1 }), { mouse = true })






      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
      hl.bind("ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

      -- Kill / close
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())

      -- Window rules
      hl.window_rule({ match = { title = "(.*)" }, no_blur = true })

      hl.window_rule({ match = { class = "ghostty" }, workspace = "1" })
      hl.window_rule({ match = { class = "google-chrome" }, workspace = "2" })
      hl.window_rule({ match = { class = "code" }, workspace = "3" })
      hl.window_rule({ match = { class = "slack" }, workspace = "4" })

      -- Dialogs
      hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Save As)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Library)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "(Volume Control)" }, float = true })
      hl.window_rule({ match = { title = "(Network Connections)" }, float = true })
      hl.window_rule({ match = { title = "(.blueman-manager-wrapped)" }, float = true })
      hl.window_rule({ match = { class = "nemo", title = "( Properties)$" }, float = true })
    '';
  };

  services = {
    dunst = {
      enable = true;

      # tries to mimic Tokyonight-Dark-B-LB
      settings = {
        global = {
          width = "(0, 300)";
          height = "(0, 100)";
          offset = "(5, 5)";

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
          lock_cmd = "pidof hyprlock || hyprlock --grace 5";
          # lock before suspend
          before_sleep_cmd = "loginctl lock-session";
          # to avoid having to press a key twice to turn on the display
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          # dim monitor backlight after 2.5 mins
          {
            timeout = 150;
            on-timeout = "brightnessctl -s && brightnessctl set 10%";
            on-resume = "brightnessctl -r";
          }
          # turn off keyboard backlight after 2.5 mins
          {
            timeout = 150;
            on-timeout = "brightnessctl -d tpacpi::kbd_backlight -s && brightnessctl -d tpacpi::kbd_backlight set 0";
            on-resume = "brightnessctl -d tpacpi::kbd_backlight -r";
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
        hide_cursor = true;
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

  # xdg-desktop-portal-hyprland config: force SHM buffers for screencopy
  # Fixes gnome-network-displays (Miracast) frozen frame issue where XDPH
  # tries DMA-BUF but pipewiresrc requests wl_shm, causing buffer exhaustion
  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      force_shm = true
    }
  '';
}
