{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
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

  environment.variables.EDITOR = "vim";
}
