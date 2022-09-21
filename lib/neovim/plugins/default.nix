{ inputs, pkgs }:
let
  plugin = attrs: pkgs.vimUtils.buildVimPluginFrom2Nix ({
    version = attrs.src.shortRev;
    dependencies = [];
  } // attrs);
in rec {
  plenary = plugin {
    pname = "plenary.nvim";
    src = inputs.plenary;
  };

  popup = plugin {
    pname = "popup.nvim";
    src = inputs.popup;
  };

  oh-my-vim = plugin {
    pname = "oh-my-vim";
    src = inputs.oh-my-vim;
    dependencies = [
      popup
      nvim-web-devicons
      telescope
      telescope-ui-select
      telescope-tele-tabby
      nvim-lspconfig
      nvim-lightbulb
      nvim-cmp
      cmp-nvim-lsp
      luaSnip
      cmp_luasnip
      nvim-treesitter
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-treesitter-playground
      neovim-session-manager
      theme-dracula
      theme-tokyonight
      theme-nightfox
      nvim-tree
      barbar
      lualine
      lualine-lsp-progress
      vim-fugitive
      vim-rhubarb
      gitsigns
      comment-nvim
      nvim-colorizer
    ];
  };

  nvim-web-devicons = plugin {
    pname = "nvim-web-devicons";
    src = inputs.nvim-web-devicons;
  };

  telescope = plugin {
    pname = "telescope.nvim";
    src = inputs.telescope;
    dependencies = [ plenary ];
  };

  telescope-ui-select = plugin {
    pname = "telescope-ui-select.nvim";
    src = inputs.telescope-ui-select;
    dependencies = [ telescope ];
  };

  telescope-tele-tabby = plugin {
    pname = "telescope-tele-tabby.nvim";
    src = inputs.telescope-tele-tabby;
  };

  nvim-lspconfig = plugin {
    pname = "nvim-lspconfig";
    src = inputs.nvim-lspconfig;
  };

  nvim-lightbulb = plugin {
    pname = "nvim-lightbulb";
    src = inputs.nvim-lightbulb;
  };

  nvim-cmp = plugin {
    pname = "nvim-cmp";
    src = inputs.nvim-cmp;
  };

  cmp-nvim-lsp = plugin {
    pname = "cmp-nvim-lsp";
    src = inputs.cmp-nvim-lsp;
  };

  luaSnip = plugin {
    pname = "luaSnip";
    src = inputs.luaSnip;
  };

  cmp_luasnip = plugin {
    pname = "cmp_luasnip";
    src = inputs.cmp_luasnip;
  };

  nvim-treesitter = plugin {
    pname = "nvim-treesitter";
    src = inputs.nvim-treesitter;
  };

  nvim-treesitter-refactor = plugin {
    pname = "nvim-treesitter-refactor";
    src = inputs.nvim-treesitter-refactor;
  };

  nvim-treesitter-textobjects = plugin {
    pname = "nvim-treesitter-textobjects";
    src = inputs.nvim-treesitter-textobjects;
  };

  nvim-treesitter-playground = plugin {
    pname = "nvim-treesitter-playground";
    src = inputs.nvim-treesitter-playground;
  };

  neovim-session-manager = plugin {
    pname = "neovim-session-manager";
    src = inputs.neovim-session-manager;
  };

  theme-dracula = plugin {
    pname = "theme-dracula";
    src = inputs.theme-dracula;
  };

  theme-tokyonight = plugin {
    pname = "theme-tokyonight.nvim";
    src = inputs.theme-tokyonight;
  };

  theme-nightfox = plugin {
    pname = "theme-nightfox.nvim";
    src = inputs.theme-nightfox;
  };

  nvim-tree = plugin {
    pname = "nvim-tree";
    src = inputs.nvim-tree;
  };

  barbar = plugin {
    pname = "barbar.nvim";
    src = inputs.barbar;
  };

  lualine = plugin {
    pname = "lualine.nvim";
    src = inputs.lualine;
  };

  lualine-lsp-progress = plugin {
    pname = "lualine-lsp-progress";
    src = inputs.lualine-lsp-progress;
  };

  vim-fugitive = plugin {
    pname = "vim-fugitive";
    src = inputs.vim-fugitive;
  };

  vim-rhubarb = plugin {
    pname = "vim-rhubarb";
    src = inputs.vim-rhubarb;
  };

  gitsigns = plugin {
    pname = "gitsigns.nvim";
    src = inputs.gitsigns;
  };

  comment-nvim = plugin {
    pname = "comment-nvim";
    src = inputs.comment-nvim;
  };

  nvim-colorizer = plugin {
    pname = "nvim-colorizer";
    src = inputs.nvim-colorizer;
  };
}
