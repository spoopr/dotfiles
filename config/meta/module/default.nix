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

    filled = path
        |> import
        |> (content: if (lib.isFunction content)
            then content
                |> builtins.functionArgs
                |> builtins.attrNames
                |> (x: lib.getAttrs
                    x
                    (
                        args
                        // {
                            inherit cfg;
                            # inject current-flake and
                            # dotfile-declared attributes
                            dots = {
                                inherit (current-flake-args) inputs;
                                inherit (config.dotfiles.meta) args;
                            };
                        }
                    )
                )
                |> import path
             else content
        );
in {
    imports = if (builtins.hasAttr
        "imports"
        filled
    )
        then filled.imports
        else [];


    options = lib.setAttrByPath
        components
        {
            enable = lib.mkOption {
                default = false;
                type = lib.types.bool;
            };
        };

    config = let
        guarantees = [
            "dotfiles"
        ];

    in lib.mkMerge (
        # always add particular attributes
        (map
            (key: if (builtins.hasAttr
                key
                filled
            )
                then filled
                    |> builtins.getAttr key 
                    |> lib.setAttrByPath [ key ]
                else {}
            )
            guarantees
        ) ++ [ (lib.mkIf
            (
                cfg.enable
                || (components
                    |> config.dotfiles.meta.forceEnable.forComponents
                    |> (result: if (result != null)
                        then result
                        else false
                    )
                )
            )
            (removeAttrs
                filled
                (guarantees ++ [
                    # since this is being pulled earlier
                    "imports"
                ])
            )
        )]
    );

}
