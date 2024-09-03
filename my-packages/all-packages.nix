{ pkgs, ... }:

{
  dcpt500wlpr = (pkgs.pkgsi686Linux.callPackage ./dcpt500w { }).driver;
  dcpt500w-cupswrapper = (pkgs.callPackage ./dcpt500w { }).cupswrapper;
  # upm = pkgs.callPackage ./upm { }
}
