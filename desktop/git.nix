{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "kmate";
        email = "mtkarc@gmail.com";
      };
      alias = {
        br = "branch";
        ci = "commit";
        co = "checkout";
        st = "status";
      };
      init.defaultBranch = "main";
    };
  };
}
