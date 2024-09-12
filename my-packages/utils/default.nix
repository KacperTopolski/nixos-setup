{ pkgs, lib, stdenv, writers, makeWrapper, symlinkJoin }:

let
  screentool = pkgs.writeShellScriptBin "screentool" ''
    loc=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)
    ${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -caf /tmp/$loc.png
    ${pkgs.cinnamon.xviewer}/bin/xviewer -n /tmp/$loc.png
    rm /tmp/$loc.png
  '';
in symlinkJoin {
  name = "utils";
  paths = [ screentool ];
}
