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
  };

  outputs = { self, nixpkgs, impermanence, lanzaboote, agenix } @ inputs: {  
    nixosConfigurations = import ./hosts inputs; 
    nixosModules = {
      system = import ./system;
    };
 
  };
}
