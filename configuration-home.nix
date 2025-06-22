{ config, pkgs, ... }:

{
  systemd.user.services.conky-service = {
    Service = {
      Restart = "always";
      RestartSec = "1";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
      ExecStart = "${pkgs.conky}/bin/conky -c /etc/nixos/conky.conf";
    };
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };

  dconf.settings = {
    "org/cinnamon/desktop/keybindings/wm" = {
      switch-to-workspace-left = [ "<Primary><Super>Left" ];
      switch-to-workspace-right = [ "<Primary><Super>Right" ];
      switch-to-workspace-up = [ "<Primary><Super>Up" ];
      switch-to-workspace-down = [ "<Primary><Super>Down" ];
    };
    "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
      binding = [ "<Shift><Super>s" ];
      command = "screentool";
      name = "screentool";
    };
  };

  programs.git = {
    enable = true;
    userName  = "Kacper Topolski";
    userEmail = "kacpertopolski@op.pl";
    aliases = {
      co = "checkout";
      st = "status";
    };
    extraConfig = {
      push.autoSetupRemote = true;
      pull.rebase = true;
      safe.directory = "*";
    };
  };

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    # Extensions
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

  home.file = {
    ".factorio".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/state/factorio";
  };

  home.stateVersion = "25.05";
}
