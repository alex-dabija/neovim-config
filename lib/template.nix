# Mustache templates based on https://pablo.tools/blog/computers/nix-mustache-templates/

{ lib, stdenv, mustache-go }:
name: template: data:
  stdenv.mkDerivation {
    inherit name;

    nativeBuildInputs = [ mustache-go ];

    passAsFile = [ "jsonData" ];
    jsonData = builtins.toJSON data;

    phases = [ "buildPhase" "installPhase" ];

    buildPhase = ''
      ${mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
      chmod ugo+x rendered_file
    '';

    installPhase = ''
      cp rendered_file $out
    '';
  }
