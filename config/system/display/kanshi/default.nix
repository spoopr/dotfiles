{
    pkgs,
    dots,
    lib,
    ...
}: let
    inherit (dots.inputs) wrappers;
in {
    environment.systemPackages = {
        inherit pkgs;
        package = pkgs.kanshi;

        flags."--config" = ./config.conf;
    }
        |> wrappers.lib.wrapPackage
        |> lib.singleton
    ;
}
