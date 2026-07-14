{
  import-tree,
  ...
}: let
    imports = import-tree ./.;
in {
    imports = builtins.trace
        imports
        imports;
}
