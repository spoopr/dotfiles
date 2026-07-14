{
  inputs,
  ...
}: let
    inherit (inputs) import-tree;
in {
    imports = [ (import-tree
        |> (x: x.match ".+\/default\.nix")
        |> (x: x.addPath ./.)
        |> (x: x.result)
    ) ];
}
