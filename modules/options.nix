# Based on https://github.com/gytis-ivaskevicius/nix2vim/blob/master/lib/api.options.nix
{ lib, pkgs, config, ... }:
let
  types = lib.types;
in {
  options = {
    plugins = lib.mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of Neovim plugins to be installed and autoloaded.";
      example = lib.literalExpression + ''
        with pkgs.vimPlugins; [ telescope ]
      '';
    };

    vim = lib.mkOption {
      type = types.attrs;
      default = { };
      description = "The `vim` namespace from Neovim's lua API.";
      example = {
        vim.o.spelllang = "en_us";
        vim.g.noswapfile = true;
      };
    };
  };
}
