{ inputs, pkgs }:
let
  plugin = pname: src: pkgs.vimUtils.buildVimPluginFrom2Nix {
    inherit pname src;
    version = src.shortRev;
  };
in {
  telescope = plugin "telescope.nvim" inputs.telescope;
  lualine = plugin "lualine.nvim" inputs.lualine;
}
