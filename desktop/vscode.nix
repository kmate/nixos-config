{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "explorer.confirmDelete" = false;
      "platformio-ide.useBuiltinPIOCore" = false;
      "update.mode" = "none";
    };
  };
}
