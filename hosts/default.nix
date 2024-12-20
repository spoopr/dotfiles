{
  nixpkgs,
  self,
  impermanence,
  lanzaboote,
  ...
}: let
  inherit (self) inputs;
  
  mkHost = { name, system, users }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        { 	
          networking.hostName = name;
        }
        ./${name}
        ./${name}/hardware-configuration.nix
        impermanence.nixosModules.impermanence
        lanzaboote.nixosModules.lanzaboote
      ] ++ map (x: ../users/${x}) users	 
      ++ builtins.attrValues self.nixosModules;
      specialArgs = {
        pkgs = nixpkgs.legacyPackages.${system};
      };	          
    };

in {
  a = mkHost {
    name = "qwerty";
    system = "x86_64-linux"; 
    users = [
      "spoopr"
    ];
  };
}
