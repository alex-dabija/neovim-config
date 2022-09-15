{ lib, stdenv, symlinkJoin }:

neovim:
  let
    wrapper = {
      viAlias ? false,
      vimAlias ? false,
    }:
      let
        wrapperArgs = [ "1" "2" "3" ];

        template = lib.templateFile "test.sh" ./test.sh.mustache {
          message = "Hello, world from a mustache template!";
          options = {
            executable = true;
          };
        };
      in
        symlinkJoin {
          name = "${lib.getName neovim}-${lib.getVersion neovim}";
          paths = [ neovim ];

          postBuild = lib.optionalString stdenv.isLinux ''
            ${template.outPath}
          '';
        };
  in
    lib.makeOverridable wrapper
