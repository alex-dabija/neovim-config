{ pkgs }:
let
  lib = pkgs.lib;

  toLua = name: obj:
    lib.concatStringsSep "\n" (lib.sort builtins.lessThan (builtins.map toStringStatement (flatten obj [ name ])));

  toStringStatement = data:
    let
      path = lib.concatStringsSep "." data.path;
    in
      "${path} = ${toLuaString data.value};";

  toLuaString = value:
    if lib.isInt value then
      intToLua value
    else if lib.isBool value then
      booleanToLua value
    else if lib.isString value then
      "\"${value}\""
    else abort "Unknown type for value: '${value}'.";

  flatten = value: path:
    let
      fieldNames = lib.attrNames value;
    in
      if lib.isAttrs value
        then
          lib.concatLists (builtins.map (field: flatten value.${field} (path ++ [ field ])) fieldNames)
        else
          [ { inherit path value; } ];

  intToLua = value: builtins.toString value;
  booleanToLua = value: if value then "true" else "false";

in {
  inherit toLua;
}
