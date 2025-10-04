# Recovery / reinstall

In case the system needs a reinsall:

1. Boot the nixos installer from a pendrive (use F12 to enter the boot menu). Secure boot needs to be disabled.

2. Set up WIFI, mount backup SSD.

3. Open terminal and become root, `sudo su -`.

4. Open encrypted partition:

```sh
DISK=/dev/nvme0n1
cryptsetup open "$DISK"p2 enc
```

5. Mount BTRFS in read-only recovery mode:

```sh
mount -t btrfs -o rescue=all,ro /dev/lvm/root /mnt
```

6. Backup contents of `/persist`:

```sh
BACKUP=/run/media/nixos/Extreme\ SSD/nixos
cp -R /mnt/persist $BACKUP
```

7. Backup contents of `/home/km`, as needed:

Refresh include list, and adjust manually if needed:
```sh
ls -a $BACKUP/home/km/ > $BACKUP/home/km.include.txt
```

Use rsync to copy all those folders in the include list to the backup drive:
```sh
cat $BACKUP/home/km.include.txt | while read line; do rsync -av --progress /mnt/home/km/$line/ $BACKUP/home/km/$line; done
```

Copy regular files, like the zsh history as well:

```sh
rsync -vlptgo --no-r --no-R --no-d --progress /mnt/home/km/* $BACKUP/home/km/
```

8. Unmount old file system

```sh
umount /mnt
```

9. Re-create file systems:

```
mkswap /dev/lvm/swap
swapon /dev/lvm/swap

mkfs.btrfs -f /dev/lvm/root

# Then create subvolumes

mount -t btrfs /dev/lvm/root /mnt

# We first create the subvolumes outlined above:
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log

# We then take an empty *readonly* snapshot of the root subvolume,
# which we'll eventually rollback to on every boot.
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

# Mount the directories

mount -o subvol=root,compress=zstd,noatime /dev/lvm/root /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/lvm/root /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/lvm/root /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/lvm/root /mnt/persist

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime /dev/lvm/root /mnt/var/log

# don't forget this!
mkdir /mnt/boot
mount "$DISK"p1 /mnt/boot
```

10. Restore `/persist` from backup:

```sh
cp -R $BACKUP/persist/* /mnt/persist/
```

11. Check hardware config in `hardware.nix` against `blkid`.

New file systems will have new UUIDs.

Do the required changes, do not forget to push to git later.

12. Reinstall nixos:

Edit `flake.nix` to enable the `boot.nix` module instead of `secureboot.nix`.

```sh
cd $BACKUP/nixos-config
nixos-install --flake .#x --root /mnt
```

Note that this might not work if you have a `.git` folder inside, in that case just remove it.

This will download several gigabytes of data as it executes full system installation.

13. Restore `/home/km`:

```sh
rsync -av --progress $BACKUP/home/km /mnt/home/
```

Make sure that all files are having the correct owner now and permissions:

```sh
nixos-enter --root /mnt
chown -R km:users /home/km
chmod og-rx -R ~/.ssh
exit
```

Reboot into the new system, while secure boot is still disabled.

14. Re-enable secure boot

Run `bootctl status` to see if `systemd-boot` is the boot loader.

If you have the existing keys, migrate them by `sbctl setup --migrate`.

Otherwise, create keys with `sudo sbctl create-keys`.

Check preconditions: `sudo sbctl verify`.

Edit `flake.nix` to re-enable the `secureboot.nix` module instead of `boot.nix`.

When you created new keys, reboot then turn the firmware into key enrollment mode, by executing the following.

The UEFI firmware allows enrolling Secure Boot keys when it is in Setup Mode.

On a Thinkpad enter the BIOS menu using the "Reboot into Firmware" entry in the systemd-boot boot menu. Once you are in the BIOS menu:

    Select the "Security" tab.
    Select the "Secure Boot" entry.
    Set "Secure Boot" to enabled.
    Select "Reset to Setup Mode".

When you are done, press F10 to save and exit.

Enroll the new keys: `sudo sbctl enroll-keys --microsoft`.

Reboot, then check `bootctl status` to see if secure boot is activated.
