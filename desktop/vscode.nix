{
  programs.vscode = {
    enable = true;
    userSettings = {
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "explorer.confirmDelete" = false;
      "platformio-ide.useBuiltinPIOCore" = false;
      "update.channel" = "none";
    };
  };
}
