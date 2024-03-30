{
  config,
  lib,
  ...
}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  networking = {
    hostName = "x";
    useDHCP = lib.mkDefault true;
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
