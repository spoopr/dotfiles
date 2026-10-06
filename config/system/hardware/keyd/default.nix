{
    lib,
    cfg,
    ...
}: {
    dotfiles.self = {
        options = {
            capslockToCtrl = lib.mkOption {
                type = with lib.types; bool;
                default = false;
            };
        };

        forceEnable = cfg.options
            |> builtins.attrValues
            |> builtins.any (x: x);
    };

    services.keyd = {
        enable = true;

        keyboards.default = {
            ids = [ "*" ];

            settings.main = lib.mergeAttrsList [
                (lib.optionalAttrs
                    cfg.options.capslockToCtrl
                    {
                        capslock = "layer(control)";
                    }
                )
            ];
        };
    };
}
