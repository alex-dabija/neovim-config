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

    telescope-tele-tabby = {
      url = "github:TC72/telescope-tele-tabby.nvim?ref=main";
      flake = false;
    };

    oh-my-vim = {
      url = "git+https://gitlab.tools.kbee.xyz/alex/oh-my-vim.git?ref=nix-config";
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

    nvim-treesitter-playground = {
      url = "github:nvim-treesitter/playground?ref=master";
      flake = false;
    };

    neovim-session-manager = {
      url = "github:Shatur/neovim-session-manager?ref=master";
      flake = false;
    };

    theme-dracula = {
      url = "github:dracula/vim?ref=master";
      flake = false;
    };

    theme-tokyonight = {
      url = "github:folke/tokyonight.nvim?ref=main";
      flake = false;
    };

    theme-nightfox = {
      url = "github:EdenEast/nightfox.nvim?ref=main";
      flake = false;
    };

    nvim-tree = {
      url = "github:kyazdani42/nvim-tree.lua?ref=master";
      flake = false;
    };

    barbar = {
      url = "github:romgrk/barbar.nvim?ref=master";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim?ref=master";
      flake = false;
    };

    lualine-lsp-progress = {
      url = "github:arkav/lualine-lsp-progress?ref=master";
      flake = false;
    };

    vim-fugitive = {
      url = "github:tpope/vim-fugitive?ref=master";
      flake = false;
    };

    vim-rhubarb = {
      url = "github:tpope/vim-rhubarb?ref=master";
      flake = false;
    };

    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim?ref=main";
      flake = false;
    };

    comment-nvim = {
      url = "github:numToStr/Comment.nvim?ref=master";
      flake = false;
    };

    nvim-colorizer = {
      url = "github:norcalli/nvim-colorizer.lua?ref=master";
      flake = false;
    };

    hop-nvim = {
      url = "github:phaazon/hop.nvim?ref=master";
      flake = false;
    };

    vim-oscyank = {
      url = "github:ojroques/vim-oscyank?ref=main";
      flake = false;
    };

    nvim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua?ref=main";
      flake = false;
    };

    vim-surround = {
      url = "github:tpope/vim-surround?ref=master";
      flake = false;
    };

    vim-repeat = {
      url = "github:tpope/vim-repeat?ref=master";
      flake = false;
    };

    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs?ref=master";
      flake = false;
    };

    octo-nvim = {
      url = "github:pwntester/octo.nvim?ref=master";
      flake = false;
    };

    nvim-notify = {
      url = "github:rcarriga/nvim-notify?ref=master";
      flake = false;
    };

    nvim-legendary = {
      url = "github:mrjones2014/legendary.nvim?ref=master";
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
            ./modules/colorscheme.nix
          ];
          specialArgs = { inherit pkgs; inputs = self.inputs; };
        };

      in rec {
        inherit pkgs;
        config = modules.config;

        overlays = {
          neovimPlugins = (final: prev: {
            neovimPlugins = plugins;
          });
        };

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
