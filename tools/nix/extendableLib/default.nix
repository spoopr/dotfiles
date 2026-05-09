# credit to srid at
# https://nixos.zulipchat.com/#narrow/stream/419910-flake-parts/topic/Overriding.20.60lib.60.20in.20flake-parts
# for the vehicle
{
  nixpkgs,
  config,
  flake-parts-lib,
  lib,
  ...
}: let
    inherit (lib) types;
in {
    options.perSystem = flake-parts-lib.mkPerSystemModule ({
      ...
    }: {
       options = {
            libOverlays = lib.mkOption {
                type = types.listOf types.attrs;
                default = [];
                internal = true;
            };
       };
    });

    config.perSystem = {
      system,
      ...
    }: {
        _modules.args.pkgs = import nixpkgs {
            inherit system;

            overlays = config.libOverlays;
        };
    };
}
