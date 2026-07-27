{
    current-flake-args,
    pathToLabel,
    ...
}: let
    inherit (current-flake-args.inputs.nixpkgs) lib;

    # abuse the merge ability of module types to "track" what
    # file the definition came from
    #
    # i'm doing this shit just so i can force one option to work as multiple
    # smaller ones and kick the solving to the module system
    trackableType = {
        merge = location: definitions: definitions
            |> map
                ({
                    file,
                    value
                }: {
                    file = file
                        |> (x: /. + x)
                        |> pathToLabel;
                    inherit value;
                })
            |> (definitions: {
                files = map
                    ({ file, ... }: file)
                    definitions;
                forComponents = components: definitions
                    |> lib.filter
                        ({file, ...}: file == components)
                    |> (list: if (builtins.length list == 0)
                        then null
                        else list
                            |> builtins.head
                            |> builtins.getAttr "value"
                    );
            });
    };
in {
    dotfiles.meta = {
        forceEnable = lib.mkOption {
            default = false;
            type = lib.types.bool
                // trackableType;
        };
        
        args = lib.mkOption {
            default = {};
            type = lib.types.attrs;
        };
    };
}
