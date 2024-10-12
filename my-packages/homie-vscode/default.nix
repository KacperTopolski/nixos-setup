{
  lib,
  fetchFromGitHub,
  vscode-utils,
}:

let
  pname = "homie-vscode";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "MisieqqeisiM";
    repo = "homie-vscode";
    rev = "6ff1ce8";
    hash = "sha256-XWX2x1xueAYoAgm9zxJb72TTSVw/KMl1vIthO8iXWWw=";
  };
in
vscode-utils.buildVscodeExtension {
  name = "${pname}-${version}";
  inherit version;
  inherit src;
  vscodeExtUniqueId = pname;
  vscodeExtPublisher = pname;
  vscodeExtName = pname;
  setSourceRoot = "sourceRoot=.";
  postInstall = "mv $out/share/vscode/extensions/${pname}/source/* $out/share/vscode/extensions/${pname}/";
}
