{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/persist/age/keys.txt";

    secrets."network-manager.env" = {};
    secrets."passwords.km" = {
      neededForUsers = true;
    };
  };

  programs.seahorse.enable = true;
  services = {
    dbus.packages = [pkgs.gnome.seahorse];
    gnome.gnome-keyring.enable = true;
  };
  security.pam.services.gdm.enableGnomeKeyring = true;
}
