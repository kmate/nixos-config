{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;

    users.km = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "video"];
      packages = with pkgs; [
        google-chrome
      ];
      hashedPasswordFile = config.sops.secrets."passwords.km".path;
    };
  };
}
