{
  inputs,
  nixpkgs,
  ...
}: {
  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      # high priority since it's almost always used
      "https://cache.nixos.org?priority=10"
      "https://anyrun.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--use-remote-sudo"
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "13:00";
    randomizedDelaySec = "45min";
  };
}
