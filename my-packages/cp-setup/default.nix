{ pkgs, lib, stdenv, writers, makeWrapper, symlinkJoin }:

let
  cpsol = pkgs.writeShellScriptBin "cpsol" ''
    for var in "$@"
    do
      cat ${./sol.cpp} > $var.cpp
    done
  '';
  bits_file = pkgs.runCommand "bits_file" {} ''
    mkdir $out
    ${pkgs.gcc}/bin/g++ -H ${./sol.cpp} 2>&1 | grep "bits/stdc++.h" | tail -n 1 > $out/path
    cp $(cat $out/path) $out/stdc++.h
  '';
  c_command = ''
    ${pkgs.gcc}/bin/g++ -std=c++20 -Wall -Wextra -Wshadow -Wconversion \
    -Wno-sign-conversion -Wfloat-equal -D_GLIBCXX_DEBUG \
    -D_GLIBCXX_DEBUG_PEDANTIC -fsanitize=address,undefined \
    -ggdb3 -DLOC \
  '';
  cf_command = ''
    ${pkgs.gcc}/bin/g++ -std=c++20 -O3 -DLOC \
  '';
  c_bits = pkgs.runCommand "c_bits" {} ''
    mkdir -p $out/bits
    cd $out/bits
    cp ${bits_file}/stdc++.h .
    ${c_command} stdc++.h || true
    rm stdc++.h
  '';
  cf_bits = pkgs.runCommand "cf_bits" {} ''
    mkdir -p $out/bits
    cd $out/bits
    cp ${bits_file}/stdc++.h .
    ${cf_command} stdc++.h || true
    rm stdc++.h
  '';
  c = pkgs.writeShellScriptBin "c" "${c_command} -I${c_bits} $1.cpp -o$1";
  cf = pkgs.writeShellScriptBin "cf" "${cf_command} -I${cf_bits} $1.cpp -o$1";
in symlinkJoin {
  name = "cp-setup";
  paths = [ cpsol c cf ];
}
