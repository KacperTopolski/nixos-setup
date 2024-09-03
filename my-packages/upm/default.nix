{ lib, stdenv, writers, jdk, fetchurl, makeWrapper, ant, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "upm";
  version = "1.15.1";

  nativeBuildInputs = [ ant jdk makeWrapper copyDesktopItems ];

  src = fetchurl {
    url = "mirror://sourceforge/upm/upm-src-${version}.tar.gz";
    sha256 = "3AvXA633pXKnXnNy1IdX9KKvQ7mmAQFkDzL9iJKEsPg=";
  };

  buildPhase = ''
    sed -i "s/source=\"6\" target=\"1.6\"/source=\"8\" target=\"1.8\"/g" build.xml
    ant 
  '';

  installPhase = ''
    runHook preInstall
    install -D images/128x128/upm.png $out/share/icons/upm.png
    install -D dist/build/upm.jar $out/lib/upm.jar
    cp -r lib/* $out/lib/
    makeWrapper ${jdk}/bin/java $out/bin/upm --add-flags "-jar $out/lib/upm.jar"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "UPM";
      desktopName = "UPM";
      icon = "upm";
      comment = "Password manager";
      categories = [ "Utility" ];
      exec = "upm";
    })
  ];

  meta = with lib; {
    description = "Simple open source password manager";
    mainProgram = "upm";
    homepage = "https://upm.sourceforge.net/index.html";
    license = licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
  };
}
