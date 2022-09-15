{ lib, stdenv, symlinkJoin }:

neovim:
  let
    wrapper = {
      viAlias ? false,
      vimAlias ? false,
    }@args:
      let
        context = {
          # Arguments with default values are not captured by `@args`.
          inherit viAlias vimAlias;
        } // args;

        postBuildScript = lib.templateExecutableFile "wrapper-postbuild.sh" ./wrapper-postbuild.sh.mustache context;
      in
        symlinkJoin {
          name = "${lib.getName neovim}-${lib.getVersion neovim}";
          paths = [ neovim ];
          postBuild = "source ${postBuildScript}";

          meta = neovim.meta // {
            priority = (neovim.meta.priority or 0) - 1; # Prefer wrapped over plain Neovim
          };
        };
  in
    lib.makeOverridable wrapper
