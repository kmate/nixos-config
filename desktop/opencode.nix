{ inputs, ... }:
{
  programs.opencode = {
    enable = true;
    package = inputs.opencode.packages.x86_64-linux.default;
    settings = {
      theme = "tokyonight";
      autoupdate = true;
    };
  };
}
