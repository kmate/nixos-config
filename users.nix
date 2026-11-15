{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;

    users.km = {
      isNormalUser = true;
      extraGroups = ["wheel" "dialout" "networkmanager" "video" "scanner" "lp"];
      packages = with pkgs; [
        google-chrome
        simple-scan
      ];
      hashedPasswordFile = config.sops.secrets."passwords.km".path;
    };
  };
}
