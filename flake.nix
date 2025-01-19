{
  description = "augh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    secrets.url = "/nix/persist/secrets";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    hosts = import ./hosts inputs;
    systemConfiguration = import ./system;
    moduleConfiguration = import ./config;

    mkConfig =  name: host: nixpkgs.lib.nixosSystem {
        inherit (host) system;

        modules = host.hardwareModules 
	++ (with inputs; [
	  impermanence.nixosModules.impermanence
	  lanzaboote.nixosModules.lanzaboote
	  agenix.nixosModules.default
	  secrets.nixosModules.secrets

	  moduleConfiguration
	  systemConfiguration
        ]);

	specialArgs = {
	  pkgs = nixpkgs.legacyPackages.${host.system};
	  inherit inputs;

	  inherit host;
	  hostName = name;
	};
      };

  in {  
    nixosConfigurations =  builtins.mapAttrs mkConfig hosts;
  };
}
