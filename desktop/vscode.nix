{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      ziglang.vscode-zig
    ];
    profiles.default.userSettings = {
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "explorer.confirmDelete" = false;
      "platformio-ide.useBuiltinPIOCore" = false;
      "update.mode" = "none";
    };
  };
}
