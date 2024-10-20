{ pkgs, lib, stdenv, writers, makeWrapper, symlinkJoin }:

let
  screentool = pkgs.writeShellScriptBin "screentool" ''
    loc=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)
    ${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -caf /tmp/$loc.png
    ls /tmp/$loc.png || exit
    ${pkgs.cinnamon.xviewer}/bin/xviewer -n /tmp/$loc.png
    rm /tmp/$loc.png
  '';
  activate_state = pkgs.writeShellScriptBin "activate_state" ''
    state=/home/$USER/state

    rmdir ~/Desktop || rm ~/Desktop
    rmdir ~/.factorio || rm ~/.factorio
    rmdir ~/.ssh || rm ~/.ssh
    sudo rmdir /etc/nixos || sudo rm /etc/nixos
    sudo rmdir /state || sudo rm /state

    ln -s $state/desktop ~/Desktop
    ln -s $state/factorio ~/.factorio
    ln -s $state/dotfiles/.ssh ~/.ssh
    sudo ln -s $state/nixos /etc/nixos
    sudo chmod 777 /etc/nixos
    sudo ln -s $state /state
  '';
in symlinkJoin {
  name = "utils";
  paths = [ screentool activate_state ];
}
