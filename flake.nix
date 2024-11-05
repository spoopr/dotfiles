{
  description = "augh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } @ inputs: {  
    nixosConfigurations = import ./hosts inputs; 
    nixosModules = {
      system = import ./system;
    };
 
  };
}
