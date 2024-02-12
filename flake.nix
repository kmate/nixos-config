{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
  };

  outputs = {
    self,
    nixpkgs,
    lanzaboote,
    impermanence,
    sops-nix,
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
          lanzaboote.nixosModules.lanzaboote # TODO is there a way to import these in the specific files?
          ./secureboot.nix
          impermanence.nixosModules.impermanence
          ./impermanence.nix
          sops-nix.nixosModules.sops
          ./secrets.nix
          ./network.nix
          ./gui.nix
          ./utils.nix
          ./users.nix
          ./fingerprint.nix
          {
            time.timeZone = "Europe/Budapest";
            i18n.defaultLocale = "en_US.UTF-8";
            i18n.supportedLocales = [
              "en_US.UTF-8/UTF-8"
              "hu_HU.UTF-8/UTF-8"
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.km = import ./home.nix; # TODO is there a way to move all these to home.nix?
              # Optionally, use extraSpecialArgs to pass
              # arguments to home.nix
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
          statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
        };
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "nixos-flake-shell"; # TODO start zsh after that's being set up?
      shellHook = ''
        ${self.checks.${system}.pre-commit-check.shellHook}
      '';
    };
  };
}
