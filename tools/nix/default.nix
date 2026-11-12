{
    lib,
    ...
}: let
    inherit (lib) types;
in {
    options.flake.lib = lib.mkOption {
        type = types.attrs
            // {
                merge = locations: definitions: definitions
                    |> lib.getValues
                    |> lib.foldl
                        (lib.recursiveUpdate)
                        {};
            };
        default = {};
    };
}
