{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
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
          ./users.nix
          ./fingerprint.nix
          ./fonts.nix
          ./desktop.nix
          {
            time.timeZone = "Europe/Budapest";
            i18n = {
              defaultLocale = "en_US.UTF-8";
              supportedLocales = [
                "en_US.UTF-8/UTF-8"
                "hu_HU.UTF-8/UTF-8"
              ];
              extraLocaleSettings = {
                LC_ADDRESS = "hu_HU.UTF-8";
                LC_IDENTIFICATION = "hu_HU.UTF-8";
                LC_MEASUREMENT = "hu_HU.UTF-8";
                LC_MONETARY = "hu_HU.UTF-8";
                LC_NAME = "hu_HU.UTF-8";
                LC_NUMERIC = "hu_HU.UTF-8";
                LC_PAPER = "hu_HU.UTF-8";
                LC_TELEPHONE = "hu_HU.UTF-8";
                LC_TIME = "hu_HU.UTF-8";
              };
            };
          }
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
