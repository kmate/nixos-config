{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ziglang.vscode-zig
      ];
      userSettings = {
        "files.trimFinalNewlines" = true;
        "files.insertFinalNewline" = true;
        "explorer.confirmDelete" = false;
        "platformio-ide.useBuiltinPIOCore" = false;
        "update.mode" = "none";
      };
    };
  };
}
