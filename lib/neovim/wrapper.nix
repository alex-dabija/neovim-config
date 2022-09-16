{ lib, stdenv, symlinkJoin, makeWrapper }:

neovim:
  let
    wrapper = {
      viAlias ? false,
      vimAlias ? false,
    }@args:
      let
        context = {
          # Arguments with default values are not captured by `@args`.
          inherit viAlias vimAlias neovim;
          luaPath = neovim.passthru.luaPath;
          luaCPath = neovim.passthru.luaCPath;
          inherit remoteProvidersCommand;
        } // args;

        postBuildScript = lib.templateExecutableFile "wrapper-postbuild.sh" ./wrapper-postbuild.sh.mustache context;

        remoteProvidersCommand =
          let
            providers = [ "python3" "ruby" "node" "perl" ];
            toSetting = provider: "let g:loaded_${provider}_provider=0";
          in
            lib.concatStringsSep " | " (builtins.map toSetting providers);
      in
        symlinkJoin {
          name = "${lib.getName neovim}-${lib.getVersion neovim}";
          paths = [ neovim ];
          postBuild = "source ${postBuildScript}";
          nativeBuildInputs = [ makeWrapper ];

          passthru = neovim.passthru;

          meta = neovim.meta // {
            priority = (neovim.meta.priority or 0) - 1; # Prefer wrapped over plain Neovim
          };
        };
  in
    lib.makeOverridable wrapper
