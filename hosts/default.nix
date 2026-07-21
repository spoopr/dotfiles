{
  inputs,
  self,
  ...
}: let
    inherit (inputs)
        import-tree
        nixpkgs;
    inherit (nixpkgs) lib;
in {
    imports = (import-tree
        |> (x: x.match ".+\/default\.nix")
        |> (x: x.addPath ./.)
        |> (x: x.withLib lib)
        |> (x: x.files)
    )
        |> builtins.map (host: let
            hostName = host
                |> lib.path.removePrefix ./.
                |> lib.path.subpath.components
                |> builtins.head;
        in {
            flake.nixosConfigurations.${hostName} =
                inputs.nixpkgs.lib.nixosSystem {
                    modules = [
                        host

                        self.nixosModules.dotfiles
                    ];

                    specialArgs = {
                        inherit inputs;
                    };
                };

        });
}
