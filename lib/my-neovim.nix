# A simplified Neovim package based on the one from nixpkgs.
# Used as a learning Nix packages exercise.
# Original package: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/default.nix
{ src, lib, stdenv, cmake, libuv, msgpack, luajit, tree-sitter, unibilium, libtermkey, libvterm-neovim, gperf, gettext }:
let
  luaEnv = luajit.withPackages (ps:
    with ps; [ lpeg mpack ]
  );
in
  stdenv.mkDerivation {
    pname = "my-neovim";
    version = "0.7.2";

    inherit src;

    patches = [
      ./system_rplugin_manifest.patch
    ];

    buildInputs = [
      libuv
      luajit.pkgs.libluv
      msgpack
      tree-sitter
      luaEnv
      unibilium
      libtermkey
      libvterm-neovim
      gperf
    ];

    nativeBuildInputs = [
      cmake
      gettext
    ];

    cmakeFlags = [
      "-DUSE_BUNDLED=OFF"
    ];

    disallowedReferences = [ stdenv.cc ];

    # Metadata from original neovim package
    meta = {
      description = "Vim text editor fork focused on extensibility and agility";
      longDescription = ''
        Neovim is a project that seeks to aggressively refactor Vim in order to:
        - Simplify maintenance and encourage contributions
        - Split the work between multiple developers
        - Enable the implementation of new/modern user interfaces without any
          modifications to the core source
        - Improve extensibility with a new plugin architecture
      '';
      homepage = "https://www.neovim.io";
      mainProgram = "nvim";
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with lib.licenses; [ asl20 vim ];
      platforms = lib.platforms.unix;
    };
  }
