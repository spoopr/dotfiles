{
  nixpkgs,
  self,
  impermanence,
  lanzaboote,
  agenix,
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
	{
	  environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
	}
        ./${name}
        ./${name}/hardware-configuration.nix
        impermanence.nixosModules.impermanence
        lanzaboote.nixosModules.lanzaboote
	agenix.nixosModules.default
      ] ++ builtins.attrValues self.nixosModules
      ++ map (x: ../users/${x}) users	 
      ++ [ ({ config, ... }: {
	users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;
      }) ];
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
