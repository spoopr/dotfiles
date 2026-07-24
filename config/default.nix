{
    moduleWithSystem,
    ...
} @ current-flake-args: let
    # to avoid overshadowing current-flake attributes, the above should be left
    # (mostly) unexpanded and used to refer to said attributes
    inherit (current-flake-args.inputs)
        import-tree;
    inherit (current-flake-args.inputs.nixpkgs) lib;

in {
    # `dotfiles` isn't really intended to be public, its just an easy way to
    # consume the configuration.
    #
    # go ham if you want, i guess
    flake.nixosModules.dotfiles = moduleWithSystem (
        # flake-parts scope
        { ... }:
        # nixos scope
        { ... }: let
            # this lambda is assigned to standardize its function across files
            pathToLabel = path: path
                    |> lib.path.removePrefix ./.
                    |> lib.path.subpath.components
                    |> (list: [ "dotfiles" ] ++ list)
                    |> (list: list
                        |> builtins.length
                        |> (length: length - 1)
                        |> builtins.elemAt list
                        |> (last: lib.remove last list)
                    );
        in {
            imports = (import-tree # get all the files
                    |> (x: x.match ".+\/default\.nix")
                    # `meta` keeps things imported by this file
                    |> (x: x.matchNot "\/meta\/.*")
                    |> (x: x.addPath ./.)
                    |> (x: x.withLib lib)
                    |> (x: x.files)
                ) # take the paths and divide them into their components,
                # relative to `config/`
                |> map (path: path
                    |> pathToLabel
                    |> (components: {
                        inherit
                            path
                            components;
                    })
                ) # use the components to create a standardized module
                |> map ({path, components}: lib.modules.importApply
                    ./meta/module
                    {
                        inherit
                            path
                            components
                            current-flake-args
                            pathToLabel;
                    }
                );

            options = import
                ./meta/options.nix
                {
                    inherit
                        current-flake-args
                        pathToLabel;
                };
        }
    );
}
