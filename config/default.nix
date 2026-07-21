{
  inputs,
  moduleWithSystem,
  ...
}: let
    inherit (inputs)
        import-tree
        nixpkgs;
    inherit (nixpkgs) lib;
in {
    # `dotfiles` isn't really intended to be public, its just an easy way to
    # consume the configuration.
    #
    # go ham if you want, i guess
    flake.nixosModules.dotfiles = moduleWithSystem (
        # flake-parts scope
        { ... }:
        # nixos scope
        { ... }: {
            imports = (import-tree # get all the files
                    |> (x: x.match ".+\/default\.nix")
                    |> (x: x.addPath ./.)
                    |> (x: x.withLib lib)
                    |> (x: x.files)
                ) # take the paths and divide them into their components,
                # relative to `config/`
                |> map (path: path
                    |> lib.path.removePrefix ./.
                    |> lib.path.subpath.components
                    |> (list: [ "dotfiles" ] ++ list)
                    |> (list: list
                        |> builtins.length
                        |> (length: length - 1)
                        |> builtins.elemAt list
                        |> (last: lib.remove last list)
                    )
                    |> (components: {
                        inherit
                            path
                            components;
                    })
                ) # use the components to create a standardized module
                |> map ({path, components}:
                    {config, ...} @ inputs: let
                        cfg = lib.getAttrFromPath
                            components
                            config;
                    in {
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
                                        |> (x: lib.getAttrs x inputs)
                                        |> lib.mergeAttrs { inherit cfg; }
                                        |> import path
                                    else content
                                )
                            );

                    }

                );
        }
    );
}
