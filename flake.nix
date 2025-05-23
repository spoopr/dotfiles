{
	description = "augh";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		impermanence.url = "github:nix-community/impermanence";
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v0.4.1";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		secrets.url = "/nix/persist/secrets";
	};

	outputs = { nixpkgs, ... } @ inputs: let

		hosts = import ./hosts inputs;
		systemConfiguration = import ./system;
		moduleConfiguration = import ./config;

		mkConfig =  name: host: nixpkgs.lib.nixosSystem {
			inherit (host) system;

			modules = host.hardwareModules 
			++ (with inputs; [
				impermanence.nixosModules.impermanence
				lanzaboote.nixosModules.lanzaboote
				secrets.nixosModules.${name}

				moduleConfiguration
				systemConfiguration
			]);

			specialArgs = {
				pkgs = nixpkgs.legacyPackages.${host.system};
				inherit inputs;
				host = host // { inherit name; };
				secrets = inputs.secrets.${name};
			};
		};

	in {  
		nixosConfigurations =  builtins.mapAttrs mkConfig hosts;
	};
}
