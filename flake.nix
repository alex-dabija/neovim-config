{
  description = "Alex's Neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?rev=e8ee6733926db83ef216497a1d660a173184ff39";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        utils = import ./lib/utils.nix { inherit pkgs; };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            utils.overlays.libraryFunctions
          ];
        };
        wrapNeovim = utils.callPackage ./lib/neovim/wrapper.nix { };
        unwrappedNeovim = utils.callPackage ./lib/neovim/default.nix {
          src = inputs.neovim;
        };

      in rec {
        inherit pkgs;
        lib = pkgs.lib;

        packages = rec {
          neovim = (wrapNeovim unwrappedNeovim) {
            viAlias = true;
            vimAlias = true;
          };
          default = neovim;
        };

        apps = rec {
          nvim = flake-utils.lib.mkApp {
            drv = packages.default;
            name = "nvim";
          };
          default = nvim;
        };
      });
}
