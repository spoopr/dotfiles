{
  inputs,
  self,
  ...
}: let
    inherit (inputs)
        import-tree
        nixpkgs
        secrets;
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

                        {
                            dotfiles.meta.args = {
                                inherit hostName;
                            };
                        }

                        # ideally this would be within `config/`, but it needs
                        # to reference `hostName`, which would cause infinite
                        # recursion in there
                        secrets.nixosModules.${hostName}
                        
                        self.nixosModules.dotfiles
                    ];
                };

        });
}
