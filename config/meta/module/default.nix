# current-flake scope
{
    path,
    components,
    current-flake-args,
    ...
}: let
    inherit (current-flake-args.inputs.nixpkgs) lib;
in
# consumer scope
{
    config,
    ...
} @ args: let
    cfg = lib.getAttrFromPath
        components
        config;
in
{
    options = lib.setAttrByPath
        components
        {
            enable = lib.mkOption {
                default = false;
                type = lib.types.bool;
            };
        };

    config = lib.mkIf
        cfg.enable
        (path
            |> import
            |> (content: if (lib.isFunction content)
                then content
                    |> builtins.functionArgs
                    |> builtins.attrNames
                    |> (x: lib.getAttrs x args)
                    |> lib.mergeAttrs {
                        inherit cfg;
                        # inject current-flake and
                        # dotfile-declared attributes
                        dots = {
                            inherit (current-flake-args) inputs;
                            args = {};
                        };
                     }
                 |> import path
                 else content
            )
        );

}
