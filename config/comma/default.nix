{
  dots,
  ...
}: let
    inherit (dots.inputs) nix-index-database;
in {
    imports = [
        nix-index-database.nixosModules.default
    ];

    programs.nix-index-database.comma.enable = true;
}
