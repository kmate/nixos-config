{pkgs, ...}: {
  home = {
    username = "km";
    homeDirectory = "/home/km";

    packages = with pkgs; [
      alejandra
      btop
      jq
      silver-searcher
      slack
      wine
      winetricks
    ];

    # The state version is required and should stay at the version you
    # originally installed.
    stateVersion = "23.11";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "kmate";
      userEmail = "mtkarc@gmail.com";
      aliases = {
        br = "branch";
        ci = "commit";
        co = "checkout";
        st = "status";
      };
    };

    vscode.enable = true;
  };
}
