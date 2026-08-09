{
  config,
  lib,
  ...
}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # NM connection files must be owner-readable only (600); directory 700.
  # Files in /persist are bind-mounted to /etc/NetworkManager/system-connections.
  system.activationScripts.fix-nm-permissions = ''
    chmod 700 /etc/NetworkManager/system-connections 2>/dev/null || true
    chmod 600 /etc/NetworkManager/system-connections/*.nmconnection 2>/dev/null || true
  '';

  networking = {
    hostName = "x";
    useDHCP = lib.mkDefault true;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        7236 # Miracast RTSP (gnome-network-displays)
        8266 # allows OTA uploads for ESP
      ];
      allowedUDPPorts = [
        7236 # Miracast
      ];
      allowedUDPPortRanges = [
        {
          from = 32768;
          to = 61000;
        } # Miracast RTP video/audio stream
      ];
    };

    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [config.sops.secrets."network-manager.env".path];
        profiles = {
          "wifi1" = {
            connection = {
              id = "\${WIFI1_SSID}";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "\$WIFI1_SSID";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "\$WIFI1_PSK";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
          "wifi2" = {
            connection = {
              id = "\$WIFI2_SSID";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "\$WIFI2_SSID";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "\$WIFI2_PSK";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
          "wifi3" = {
            connection = {
              id = "\$WIFI3_SSID";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "\$WIFI3_SSID";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "\$WIFI3_PSK";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
        };
      };
    };
  };
}
