{ stdenv }:
stdenv.mkDerivation rec {
  name = "myprinter-${version}";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/cups/model/
    cp brother_dcpt500w_printer_en.ppd $out/share/cups/model/
  '';
}

