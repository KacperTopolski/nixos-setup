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
    "org/cinnamon/desktop/keybindings" = {
      custom-list = [ "custom0" ];
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

  programs.vscode = import ./vscode.nix pkgs;

  home.file = {
    ".factorio".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/state/factorio";
    ".ssh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/state/ssh";
    "Desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/state/desktop";
    ".local/share/fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/state/fish";
  };

  home.stateVersion = "25.05";
}
