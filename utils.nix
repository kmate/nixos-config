{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      age
      brightnessctl
      btop
      curl
      git
      iftop
      just
      jq
      sbctl
      silver-searcher
      sops
      systemd
      tig
      tree
      usbutils
      util-linux
      vim
      wget
      zip
    ];
    variables.EDITOR = "vim";
  };
}
