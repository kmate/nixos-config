{
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "x";
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [config.sops.secrets."network-manager.env".path];
        profiles = {
          "\${wifi.home.ssid}" = {
            connection = {
              id = "\${wifi.home.ssid}";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "\${wifi.home.ssid}";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "\${wifi.home.psk}";
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
