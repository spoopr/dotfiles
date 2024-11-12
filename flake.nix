{
  description = "augh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, impermanence } @ inputs: {  
    nixosConfigurations = import ./hosts inputs; 
    nixosModules = {
      system = import ./system;
    };
 
  };
}
