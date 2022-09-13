{ src }:
{ lib, stdenv, cmake, libuv, msgpack, luajit, tree-sitter, unibilium, libtermkey, libvterm-neovim, gperf, gettext }:
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
  }
