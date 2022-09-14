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
        pkgs = import nixpkgs {
          inherit system;
        };
        callPackage = path: overrides:
          let f = import path;
          in f ((builtins.intersectAttrs (builtins.functionArgs f) pkgs) // overrides);

        wrapNeovim = callPackage ./lib/neovim-wrapper.nix {
        };
        unwrappedNeovim = callPackage ./lib/my-neovim.nix {
          src = inputs.neovim;
        };

      in rec {
        packages = rec {
          neovim = wrapNeovim unwrappedNeovim;
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
