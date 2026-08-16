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
    pkgs, # `pkgs`` won't be provided for some reason unless it's requested
        #specifically here
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
                default = null;
                type = lib.types.nullOr lib.types.bool;
            };

            self = {
                forceEnable = lib.mkOption {
                    default = null;
                    type = lib.types.nullOr lib.types.bool;
                };
            };

            # raise `dotfiles.self.options` to `dotfiles.${path}.options`
            options = if (lib.hasAttrByPath
                [ "dotfiles" "self" "options" ]
                filled
            )
                then filled.dotfiles.self.options
                else {};
        };

    config = lib.mkMerge [
            # change `dotfiles.self` to `dotfiles.${path}.self`, and always add
            # it
            (if (lib.hasAttrByPath
                [ "dotfiles" "self" ]
                filled
            )
                then lib.setAttrByPath
                    components
                    {
                        # remove `self.options`, as thats promoted elsewhere.
                        self = removeAttrs
                            filled.dotfiles.self
                            [ "options" ];
                    }
                else {}
            )

            # also always add `dotfiles.meta`
            (if (lib.hasAttrByPath
                [ "dotfiles" "meta" ]
                filled
            )
                then { dotfiles.meta = filled.dotfiles.meta; }
                else {}
            )


            (lib.mkIf
                (
                    (
                        !(isNull cfg.enable)
                        && cfg.enable
                    ) || (
                        !(isNull cfg.self.forceEnable)
                        && cfg.self.forceEnable
                    )
                )
                # remove `dotfiles.self` and imports and options
                (filled
                    |> (x: lib.mergeAttrs
                        x
                        (if (lib.hasAttrByPath
                            [ "dotfiles" "self" ]
                            filled
                        )
                            then {
                                dotfiles = lib.removeAttrs
                                    filled.dotfiles
                                    [ "self" ];
                            }
                            else {}
                        )
                    )
                    |> (x: lib.removeAttrs
                        x
                        [ "imports" ]
                    )
                )
            )

            {
                assertions = [
                    {
                        assertation = builtins.elem
                            "enable"
                            components;
                        message = "The module path for the bottlecap at ${path}"
                            + " contains the component 'enable', which"
                            + " interferes with bottlecap option defaults.";
                    }
                    {
                        assertation = builtins.elem
                            "options"
                            components;
                        message = "The module path for the bottlecap at ${path}"
                            + " contains the component 'options', which"
                            + " interferes with bottlecap option defaults.";
                    }
                    {
                        assertation = builtins.elem
                            "self"
                            components;
                        message = "The module path for the bottlecap at ${path}"
                            + " contains the component 'self', which"
                            + " interferes with bottlecap option defaults.";
                    }
                ];

                warnings = lib.flatten [
                    (lib.optional
                        (
                            !(isNull cfg.enable)
                            && !(isNull cfg.self.forceEnable)
                            &&  (cfg.enable != cfg.self.forceEnable)
                        )
                        (
                            "The bottledcapped module "
                            + (builtins.concatStringsSep
                                "."
                                components
                            )
                            + " has conflicting 'enable' and "
                            + "'self.forceEnable' definitions"
                        )
                    )
                ];
            }
    ];

}
