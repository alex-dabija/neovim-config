{ pkgs, lib, stdenv }:
let
  findDependencies = plugins:
    let
      allDependencies = plugin:
        [ plugin ] ++ (lib.unique (builtins.concatLists (map allDependencies plugin.dependencies or [])));
    in
      lib.concatMap allDependencies plugins;

in {
  packDir = group: plugins:
    let
      allPlugins = findDependencies plugins;
      context = {
        inherit group;
        plugins = builtins.map toPluginObject allPlugins;
      };
      toPluginObject = plugin: {
        name = plugin.pname;
        path = plugin.outPath;
      };
      installScript = lib.templateExecutableFile "packdir-install.sh" ./packdir-install.sh.mustache context;
    in
      stdenv.mkDerivation {
        name = "vim-pack-dir";
        phases = [ "installPhase" ];
        installPhase = "source ${installScript}";
      };
}
