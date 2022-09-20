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

    popup = {
      url = "github:nvim-lua/popup.nvim?ref=master";
      flake = false;
    };

    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons?ref=master";
      flake = false;
    };

    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    telescope-ui-select = {
      url = "github:nvim-telescope/telescope-ui-select.nvim?ref=master";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    oh-my-vim = {
      url = "git+https://gitlab.tools.kbee.xyz/alex/oh-my-vim.git?ref=lua-config";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig?ref=master";
      flake = false;
    };

    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb?ref=master";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp?ref=main";
      flake = false;
    };

    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp?ref=main";
      flake = false;
    };

    luaSnip = {
      url = "github:L3MON4D3/LuaSnip?ref=master";
      flake = false;
    };

    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip?ref=master";
      flake = false;
    };

    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter?ref=master";
      flake = false;
    };

    nvim-treesitter-refactor = {
      url = "github:nvim-treesitter/nvim-treesitter-refactor?ref=master";
      flake = false;
    };

    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects?ref=master";
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
