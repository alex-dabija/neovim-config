{ pkgs }:
let
  # Loads functions from a given path and calls them with parameters from the `pkgs` attribute set. The `overrides`
  # attribute set can be used to override attributes passed to the function.
  callPackage = path: overrides:
    let
      func = import path;
    in
      func ((builtins.intersectAttrs (builtins.functionArgs func) pkgs) // overrides);
in
{
  inherit callPackage;

  overlays = {
    libraryFunctions = final: prev: {
      lib = prev.lib // {
        templateFile = callPackage ./template.nix { };
      };
    };
  };
}
