# nixos-config

# TODO

## Keyboard

Custom hungarian layout to have í and 0 at the same time:
- https://nixos.wiki/wiki/Keyboard_Layout_Customization
- https://wiki.archlinux.org/title/Xorg/Keyboard_configuration

## Fonts

Huge space around quotes, especially after ' and " in non-monospace (default?) font (just in some cases).

Some foreign language characters (mostly Asian) just don't render.

## Printscreen

- Try flameshot or swappy to improve current setup?

## Display mounting

Check if wdisplays works properly now

## Power button / options

EWW could be used to create a power menu, add invocation to Waybar?

Also, wlogout might be a simple option.

## App launcher

Configure style - make it floating!

## Screen sharing (in Slack)

Slack screen sharing needs tweak (XWayland), potentially:

```
Exec=/usr/bin/slack --enable-features=WebRTCPipeWireCapturer %U
```
(well this doesn’t seem to work - at least now)

See also https://nixos.wiki/wiki/Slack
and https://wiki.hyprland.org/0.20.0beta/Useful-Utilities/Screen-Sharing/

## Hyprland

- Review key bindings, e.g. SUPER+SHIFT+ENTER should move current window into a separate workspace if it’s not on one already

## Lock / turn off screen

- Lock screen when moving mouse to top right corner? (or add a button to waybar there!)
- Unlock PAM looks to be random
  - accepts only fingerprint when invoked from console
  - otherwise, it only accepts the password first, and attempts to use fingerprint after a failed password
- Tune the look (colors, clock font / position, etc.)

## Waybar

Show:
- date/time with calendar dropdown
- power menu icon / lock
- battery & cpu/ram usage
- network - nm-connection-editor on click
- display settings - wdisplays
- notifications, tray, mounts

Check https://wiki.gentoo.org/wiki/List_of_software_for_Wayland

------

# Usage

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
