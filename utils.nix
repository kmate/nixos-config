{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      age
      curl
      git
      just
      sbctl
      sops
      tig
      tree
      usbutils
      util-linux
      vim
      wget
    ];
    variables.EDITOR = "vim";
  };
  programs.ssh.startAgent = true; # TODO this doesn't work
}
