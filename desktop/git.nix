{
  programs.git = {
    enable = true;
    userName = "kmate";
    userEmail = "mtkarc@gmail.com";
    aliases = {
      br = "branch";
      ci = "commit";
      co = "checkout";
      st = "status";
    };
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
