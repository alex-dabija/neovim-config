{ lib, stdenv }:
{
  packDir = group: packages:
    let
      context = {
        inherit group;
        plugins = builtins.map toPluginObject packages;
      };
      toPluginObject = package: {
        name = package.pname;
        path = package.outPath;
      };
      installScript = lib.templateExecutableFile "packdir-install.sh" ./packdir-install.sh.mustache context;
    in
      stdenv.mkDerivation {
        name = "vim-pack-dir";
        phases = [ "installPhase" ];
        installPhase = "source ${installScript}";
      };
}
