{ lib, pkgs, config, ... }:
let
  types = lib.types;
in {
  options.colorscheme = lib.mkOption {
    type = types.str;
    default = "default";
    description = "Neovim color scheme.";
  };

  config = {
    lua = ''
      vim.api.nvim_exec([[colorscheme ${config.colorscheme}]], false)
    '';
  };
}
