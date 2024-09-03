{ lib, stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, file
, a2ps, coreutils, gnugrep, which, gawk }:

let
  version = "3.0.2";
  model = "dcpt500w";
in rec {
  driver = stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url =
        "https://download.brother.com/welcome/dlf101956/${model}lpr-${version}-0.i386.deb";
      sha256 =
        "+BvDELptQVYRd2clmZYTFea0cDtfJ62Dh8qGIcOzDTg=";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      g++ ${./fix.cc} -ofixcc
      ./fixcc /opt $out \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter-mod
      rm fixcc

      mv $out/opt/brother/Printers/${model}/lpd/br${model}filter-mod \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter
      chmod 777 $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brother_lpdwrapper_${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${
          lib.makeBinPath [
            gawk
            ghostscript
            a2ps
            file
            gnused
            gnugrep
            coreutils
            which
          ]
        }
    '';
  };

  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      url =
        "https://download.brother.com/welcome/dlf101957/${model}cupswrapper-${version}-0.i386.deb";
      sha256 =
        "mOT3pxYOeL+VBoVAW8yMUsF30UzlMDp3mRkXu1jyEDg=";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
        wrapProgram $f --prefix PATH : ${
          lib.makeBinPath [ coreutils ghostscript gnugrep gnused ]
        }
      done

      mkdir -p $out/share/cups/model
      ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
    '';
  };
}
