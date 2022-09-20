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
      nvim-lspconfig
      nvim-lightbulb
      nvim-cmp
      cmp-nvim-lsp
      luaSnip
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

  lualine = plugin {
    pname = "lualine.nvim";
    src = inputs.lualine;
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
}
