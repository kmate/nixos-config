{pkgs, ...}: {
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
    supportedFilesystems = ["btrfs"];
  };

  console = {
    earlySetup = true;
    # TODO the boot font is still too small, see `systemctl status systemd-vconsole-setup`
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = [pkgs.terminus_font];
    useXkbConfig = true;
  };
}
