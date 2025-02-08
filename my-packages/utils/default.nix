{ pkgs, lib, stdenv, writers, makeWrapper, symlinkJoin }:

let
  screentool = pkgs.writeShellScriptBin "screentool" ''
    loc=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)
    ${pkgs.gnome-screenshot}/bin/gnome-screenshot -caf /tmp/$loc.png
    ls /tmp/$loc.png || exit
    ${pkgs.xviewer}/bin/xviewer -n /tmp/$loc.png
    rm /tmp/$loc.png
  '';
  activate-state = pkgs.writeShellScriptBin "activate-state" ''
    state=/home/$USER/state

    rmdir ~/Desktop || rm ~/Desktop
    rmdir ~/.ssh || rm ~/.ssh
    sudo rmdir /etc/nixos || sudo rm /etc/nixos
    sudo rmdir /state || sudo rm /state

    ln -s $state/desktop ~/Desktop
    ln -s $state/dotfiles/.ssh ~/.ssh
    sudo ln -s $state/nixos /etc/nixos
    sudo chmod 777 /etc/nixos
    sudo ln -s $state /state
  '';
in symlinkJoin {
  name = "utils";
  paths = [ screentool activate-state ];
}
