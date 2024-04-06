# nixos-config

# TODO

## Keyboard

Custom hungarian layout to have í and 0 at the same time:
- https://nixos.wiki/wiki/Keyboard_Layout_Customization
- https://wiki.archlinux.org/title/Xorg/Keyboard_configuration

## Fonts

Huge space around quotes, especially after ' and " in non-monospace (default?) font (just in some cases).

Some foreign language characters (mostly Asian) just don't render.

## XWayland

Having 2x scale factor causes blur on lots of apps;

Apparently fractional scaling needs to be forcefully disabled
https://discussion.fedoraproject.torg/t/blurry-xwayland-applications-using-2x-scaling-on-fedora-39/90419

This might need glib:
https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland

```shell
gsettings set org.gnome.mutter experimental-features "[]"
```

see also https://nixos.wiki/wiki/Sway on `gsettings`

## Printscreen

- Figure out the current config, where does it save things, re-bind if needed
- Check swappy etc. on https://wiki.gentoo.org/wiki/List_of_software_for_Wayland

## Display mounting

Check if wdisplays works properly now

## Notifications

- Use dunst or mako, whichever can be better configured & styled?
- Test it with `notify-send` from `libnotify`

## URL links

Make clicking on URLs in e.g. VSCode and console work.

## Power button / options

EWW could be used to create a power menu, add invocation to Waybar

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
- Tweak look & feel; chose a better background before most probably
- “Must have” list: https://wiki.hyprland.org/0.20.0beta/Useful-Utilities/Must-have/
- Useful utils in general: https://wiki.hyprland.org/0.20.0beta/Useful-Utilities/

## Lock / turn off screen

- Lock screen when moving mouse to top right corner?
- Unlock requires an empty password before fingerprint - might be some PAM setting?
- Turning off screen doesn’t work when invoked automatically by swayidle through Hyprland - permission issue?
- Idle inhibitor doesn't seem to work on waybar - use hypridle?

## Waybar

Menus should open on the top (e.g. see skype/slack)

Show:
- date/time with calendar dropdown
- power menu icon / lock
- battery & cpu/ram usage
- network - nm-connection-editor on click
- display settings - wdisplays
- notifications, tray, mounts

Check https://wiki.gentoo.org/wiki/List_of_software_for_Waylandm

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
