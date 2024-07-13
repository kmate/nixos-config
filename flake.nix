{
  description = "NixOS Flake";

  nixConfig = {
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    pre-commit-hooks,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      x = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./nix.nix
          ./hardware.nix
          ./secureboot.nix
          ./impermanence.nix
          ./secrets.nix
          ./network.nix
          ./utils.nix
          ./locale.nix
          ./users.nix
          ./fingerprint.nix
          ./fonts.nix
          ./desktop.nix
          ./platformio.nix
          ./virtualization.nix
          ./dlna.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.km = import ./home.nix;
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
              };
            };
          }
        ];
      };
    };

    formatter.${system} = pkgs.alejandra;

    checks.${system} = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true; # formatter
          deadnix.enable = true; # detect unused variable bindings in `*.nix`
          statix.enable = true; # lints and suggestions for Nix code
        };
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "nixos-flake-shell";
      shellHook = ''
        zsh
        ${self.checks.${system}.pre-commit-check.shellHook}
      '';
    };
  };
}
