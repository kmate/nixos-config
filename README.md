# nixos-config

## Partitioning and disk encryption

Follow the guide here: https://gist.github.com/hadilq/a491ca53076f38201a8aa48a0c6afef5

A backup is available under `docs/luks-btrfs.md`.

Note that device UUIDs in `hardware.nix` might change:
update them from the UUID part of the output of `blkid`.

## Secure boot

Just follow the guide at https://nixos.wiki/wiki/Secure_Boot.
If something goes really wrong, just have an installer on a USB stick,
format the ESP and follow https://nixos.wiki/wiki/Bootloader.

## Fingerprint

Use `fprintd-enroll` to enroll your fingers.
The first invocation might fail as the reader's BIOS might already
contain samples for the given finger from a previous installation.

## Hyperland

### Keyboard layout switch

You might need to check `hyprctl devices` to get device name for keyboard,
then change the parameters of layout switch binding accordingly.

## Using this repository

Do a checkout from git, then use `just` to format/check/deploy...
To activate pre-commit hooks, say `just dev` first.

Do not forget to copy the `age` key used for the secrets into `/persist/age/keys.txt`,
and symlink that file under `~/.config/sops/age/keys.txt` for easier development.

Feel free to delete `/etc/nixos/` altogether, impermanence will do so anyways.
