{ pkgs, ... }:

{
  dcpt500wlpr = (pkgs.pkgsi686Linux.callPackage ./dcpt500w { }).driver;
  dcpt500w-cupswrapper = (pkgs.callPackage ./dcpt500w { }).cupswrapper;
  upm = pkgs.callPackage ./upm { };
  cp-setup = pkgs.callPackage ./cp-setup { };
  utils = pkgs.callPackage ./utils { };
  pdf-gear = pkgs.callPackage ./pdf-gear { };
  homie-vscode = pkgs.callPackage ./homie-vscode { };
  # temurin-bin = (import ./temurin-bin/default.nix) {stdenv=pkgs.stdenv; lib=pkgs.lib; callPackage=pkgs.callPackage;};
}
