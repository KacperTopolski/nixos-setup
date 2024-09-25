{
  lib,
  fetchFromGitHub,
  vscode-utils,
}:

let
  pname = "homie-vscode";
  versionX = "0.1";

  srcX = fetchFromGitHub {
    owner = "MisieqqeisiM";
    repo = "homie-vscode";
    rev = "6ff1ce8";
    hash = "sha256-XWX2x1xueAYoAgm9zxJb72TTSVw/KMl1vIthO8iXWWw=";
  };
in
vscode-utils.buildVscodeExtension {
  name = "${pname}-${versionX}";
  src = srcX;
  version = versionX;
  vscodeExtUniqueId = pname;
  vscodeExtPublisher = pname;
  vscodeExtName = pname;
  setSourceRoot = "sourceRoot=.";
}
