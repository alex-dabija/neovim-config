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

  ohMyVim = plugin {
    pname = "oh-my-vim";
    src = inputs.ohMyVim;
  };

  telescope = plugin {
    pname = "telescope.nvim";
    src = inputs.telescope;
    dependencies = [ plenary ];
  };

  lualine = plugin {
    pname = "lualine.nvim";
    src = inputs.lualine;
  };
}
