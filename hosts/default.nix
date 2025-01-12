{
  ...
}: let  
  mkHost = name: value: {
    inherit (value) system;

    hardwareModules = [
      {
        networking.hostName = name;
      }
      ./${name}
      ./${name}/hardware-configuration.nix
    ];
  };

in builtins.mapAttrs mkHost {
  awa = {
    system = "x86_64-linux"; 
  };
}
