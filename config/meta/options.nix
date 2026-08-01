{
    current-flake-args,
    ...
}: let
    inherit (current-flake-args.inputs.nixpkgs) lib;
in {
    dotfiles.meta = {
        args = lib.mkOption {
            default = {};
            type = lib.types.attrs;
        };
    };
}
