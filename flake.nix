{
  description = "Alex's Neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?rev=e8ee6733926db83ef216497a1d660a173184ff39";
      flake = false;
    };

    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
  };

  outputs = {self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        utils = import ./lib/utils.nix { inherit pkgs; };
        plugins = import ./lib/neovim/plugins {
          inherit pkgs;
          inputs = self.inputs;
        };
        pkgs = import nixpkgs {
          inherit system;
          inputs = self.inputs;
          overlays = [
            utils.overlays.libraryFunctions
            (final: prev: {
              neovimPlugins = plugins;
            })
          ];
        };

        modules = pkgs.lib.evalModules {
          modules = [
            ./modules/options.nix
            ./modules/wrapper.nix
            ./modules/demo.nix
          ];
          specialArgs = { inherit pkgs; inputs = self.inputs; };
        };

      in rec {
        inherit pkgs;
        config = modules.config;

        packages = rec {
          neovim = modules.config.package;
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
