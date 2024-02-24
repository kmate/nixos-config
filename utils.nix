{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      age
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
    ];
    variables.EDITOR = "vim";
  };
}
