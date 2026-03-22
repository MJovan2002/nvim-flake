{
  lib,
  ...
}:
{
  imports =
    ./.
    |> builtins.readDir
    |> lib.attrsToList
    |> builtins.filter ({ name, ... }: name != "default.nix")
    |> builtins.map ({ name, ... }: ./${name});
}
