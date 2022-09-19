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

  ohMyVim = plugin {
    pname = "oh-my-vim";
    src = inputs.ohMyVim;
    dependencies = [ popup telescope telescope-ui-select ];
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
}
