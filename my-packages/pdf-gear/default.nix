{ pkgs, lib, stdenv, writers, requireFile, makeWrapper, ant, icoutils, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "pdf-gear";
  version = "2.1.0";

  nativeBuildInputs = [ pkgs.wine64 makeWrapper icoutils copyDesktopItems ];

  src = requireFile {
    name = "PDFgear-${version}.tar.gz";
    sha256 = "5RAy7f9cZCegdy/e8AtsHCiyXiNxZgJRD6Gvj8/0uNo=";
    url = "";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r * $out/
    makeWrapper ${pkgs.wine64}/bin/wine64 $out/bin/pdf-gear --add-flags "$out/PDFLauncher.exe"
    wrestool -x -t 14 PDFLauncher.exe > $out/share/icons/pdf-gear.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "PDFgear";
      desktopName = "PDFgear";
      icon = "pdf-gear";
      comment = "PDF utility";
      categories = [ "Utility" ];
      exec = "pdf-gear";
    })
  ];

  meta = with lib; {
    description = "PDF utility";
    mainProgram = "pdf-gear";
  };
}
