# Based on https://github.com/gytis-ivaskevicius/nix2vim/blob/master/lib/api.options.nix
{ lib, pkgs, config, ... }:
let
  types = lib.types;
  luaUtils = import ../lib/lua.nix { inherit pkgs; };
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

    lua = lib.mkOption {
      type = types.lines;
      default = "";
      description = "Lua config";
    };

    package = lib.mkOption {
      type = types.package;
      description = "Neovim. The final package.";
      readOnly = true;
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

  config = {
    lua = luaUtils.toLua "vim" config.vim;
  };
}
