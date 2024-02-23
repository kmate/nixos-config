{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      age
      curl
      git
      just
      sbctl
      sops
      systemd
      tig
      tree
      usbutils
      util-linux
      vim
      wget
    ];
    variables.EDITOR = "vim";
  };
}
