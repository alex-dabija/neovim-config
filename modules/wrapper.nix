{ inputs, lib, pkgs, config, ... }:
let
  utils = import ../lib/utils.nix { inherit pkgs; };

  # TODO: Expose a single function the `lib/neovim` instead of all this wrap/unwrapped stuff...
  wrapNeovim = utils.callPackage ../lib/neovim/wrapper.nix { };
  unwrappedNeovim = utils.callPackage ../lib/neovim/default.nix { src = inputs.neovim; };
in {
  config = {
    package = (wrapNeovim unwrappedNeovim) {
      viAlias = true;
      vimAlias = true;
      plugins = config.plugins;
      initLua = config.lua;
      withRustAnalyzer = true;
      withGopls = true;
    };
  };
}
