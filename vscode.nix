pkgs:
{
  enable = true;
  mutableExtensionsDir = false;

  profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-python.python
      ms-python.vscode-pylance
      mhutchie.git-graph
      jnoortheen.nix-ide
      ms-vsliveshare.vsliveshare
    ];
    userSettings = {
      "editor.fontSize" = 12;
      "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace";
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
      "window.zoomLevel" = 1;
      "workbench.startupEditor" = "none";
      "explorer.compactFolders" = false;
      "files.trimTrailingWhitespace" = true;
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "extensions.ignoreRecommendations" = true;
      "editor.selectionClipboard" = false;
      "C_Cpp.default.cppStandard" = "c++23";
    };
    keybindings = [
      {
        key = "ctrl+c";
        command = "workbench.action.terminal.copySelection";
        when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
      }
      {
        key = "ctrl+v";
        command = "workbench.action.terminal.paste";
        when = "terminalFocus && terminalProcessSupported";
      }
    ];
  };
}
