{ lib, pkgs, config, ... }:
let
  types = lib.types;
in {
  plugins = with pkgs.neovimPlugins; [ oh-my-vim ];

  colorscheme = "nightfox";

  vim.g.mapleader = ",";

  vim.o = {
    # make sure file encoding is utf-8
    fileencoding = "utf-8";

    # keep buffers open when not displayed
    hidden = true;

    # enable 24-bit colors
    termguicolors = true; 

    # display cursor line and column when no status line is defined
    ruler = true;

    # display line numbers
    number = true;
    relativenumber = true;

    # display line limit column
    colorcolumn = 120;

    # always display sign column
    signcolumn = "yes";

    # minimal number of screen lines to keep above and below the cursor
    scrolloff = 8;

    # don't redraw screen when executing macros
    lazyredraw = true;

    # enable list mode to display special characters
    list = true;
    listchars = "tab:▸ ,eol:¬,extends:»,precedes:«,trail:•";

    # general tab behaviour
    expandtab = true;
    tabstop = 2;
    shiftwidth = 2;

    # faster current token highlight for treesitter-refactor
    updatetime = 300;

    # natural window splitting
    splitbelow = true;
    splitright = true;

    # highlight current line
    cursorline = true;
  };
}
