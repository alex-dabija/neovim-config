{ pkgs, lib, stdenv, symlinkJoin, makeWrapper, writeText }:

neovim:
  let
    wrapper = {
      viAlias ? false,
      vimAlias ? false,
      plugins ? [],
      initLua ? "",
      withRustAnalyzer ? false,
      withGopls ? false,
      withJdtls ? false,
      withPylsp ? false,
      withLualsp ? false,
    }@args:
      let
        pluginUtils = import ./plugins/utils.nix { inherit pkgs lib stdenv; };

        pythonEnv = pkgs.python310.withPackages (python-packages: with python-packages; [
          python-lsp-server
          pylsp-mypy
        ]);

        context = {
          # Arguments with default values are not captured by `@args`.
          inherit viAlias vimAlias neovim;
          luaPath = neovim.passthru.luaPath;
          luaCPath = neovim.passthru.luaCPath;
          inherit remoteProvidersCommand;
          pluginsDir = pluginUtils.packDir "nix-packer" plugins;
          initLua = "${writeText "init.lua" initLua}";
          rustAnalyzer = if withRustAnalyzer then pkgs.rust-analyzer.outPath else "";
          gopls = if withGopls then pkgs.gopls.outPath else "";
          jdtls = if withJdtls then pkgs.jdt-language-server.outPath else "";
          pylsp = if withPylsp then pythonEnv.outPath else "";
          lualsp = if withLualsp then pkgs.sumneko-lua-language-server.outPath else "";
        };

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
