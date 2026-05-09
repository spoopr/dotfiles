{
  import-tree,
  ...
}: {
    imports = [
        (import-tree
            |> (x: x.addPath ./.)
            |> (x: x.match "default\\.nix")
            |> (x: x.result)
        )
    ];
}
