dev:
  nix develop

check:
  nix flake check --print-build-logs --accept-flake-config

fmt:
  nix fmt

secrets:
  sops secrets/secrets.yaml

deploy:
  nixos-rebuild switch --flake . --use-remote-sudo --accept-flake-config

boot:
  nixos-rebuild boot --flake . --use-remote-sudo --accept-flake-config

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose --accept-flake-config

generations:
  ls -lah /nix/var/nix/profiles

up:
  nix flake update

# Update specific input
# usage: just upp i=home-manager
upp:
  nix flake lock --update-input $(i)

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
