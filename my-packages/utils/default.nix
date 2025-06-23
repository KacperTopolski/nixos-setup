{ pkgs, lib, stdenv, writers, makeWrapper, symlinkJoin }:

let
  screentool = pkgs.writeShellScriptBin "screentool" ''
    loc=/tmp/$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10).png
    ${pkgs.imagemagick}/bin/import -window root $loc
    ${pkgs.feh}/bin/feh --fullscreen $loc &
    ${pkgs.gnome-screenshot}/bin/gnome-screenshot -af $loc
    kill $!
    ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $loc
    ${pkgs.xviewer}/bin/xviewer -n $loc
  '';
in symlinkJoin {
  name = "utils";
  paths = [ screentool ];
}
