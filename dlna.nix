{lib, ...}: {
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      friendly_name = "x";
      inotify = "yes";
      media_dir = [
        "V,/home/km/Public/Videos"
      ];
    };
  };

  systemd.services.minidlna.serviceConfig = {
    ProtectHome = "read-only";
    User = lib.mkForce "km";
    Group = lib.mkForce "users";
  };
}
