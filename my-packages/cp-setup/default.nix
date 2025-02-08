{ pkgs, lib, stdenv, writers, makeWrapper, symlinkJoin }:

let
  cpsol = pkgs.writeShellScriptBin "cpsol" ''
    for var in "$@"
    do
      cat ${./sol.cpp} > $var.cpp
      touch $var.in
    done
  '';
  cphc = pkgs.writeShellScriptBin "cphc" ''
    for var in "$@"
    do
      cat ${./hcsol.cpp} > $var.cpp
    done
  '';
  bits_file = pkgs.runCommand "bits_file" {} ''
    mkdir $out
    ${pkgs.gcc}/bin/g++ -H ${./sol.cpp} 2>&1 | grep "bits/stdc++.h" | tail -n 1 > $out/path
    cp $(cat $out/path) $out/stdc++.h
  '';
  c_command = ''
    ${pkgs.gcc}/bin/g++ -std=c++23 -Wall -Wextra -Wshadow -Wconversion \
    -Wno-sign-conversion -Wfloat-equal -D_GLIBCXX_DEBUG \
    -D_GLIBCXX_DEBUG_PEDANTIC -fsanitize=address,undefined \
    -ggdb3 -DLOC \
  '';
  cf_command = ''
    ${pkgs.gcc}/bin/g++ -std=c++23 -O3 -DLOC -DLOCF \
  '';
  c_bits = pkgs.runCommand "c_bits" {} ''
    mkdir -p $out/bits
    cd $out/bits
    cp ${bits_file}/stdc++.h .
    ${c_command} stdc++.h || true
  '';
  cf_bits = pkgs.runCommand "cf_bits" {} ''
    mkdir -p $out/bits
    cd $out/bits
    cp ${bits_file}/stdc++.h .
    ${cf_command} stdc++.h || true
  '';
  c = pkgs.writeShellScriptBin "c" "${c_command} -I${c_bits} $1.cpp -o$1";
  cf = pkgs.writeShellScriptBin "cf" "${cf_command} -I${cf_bits} $1.cpp -o$1";
in symlinkJoin {
  name = "cp-setup";
  paths = [ cpsol cphc c cf ];
}
