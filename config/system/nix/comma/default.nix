{
  dots,
  ...
}: let
    inherit (dots.inputs) nix-index-database;
in {
    dotfiles.self.forceEnable = true;

    imports = [
        nix-index-database.nixosModules.default
    ];

    programs.nix-index-database.comma.enable = true;
}
