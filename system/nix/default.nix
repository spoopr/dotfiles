{
  lib,
  inputs,
  pkgs,
  ...
}: let
    inherit (inputs) self;
in {
    nix = {
        settings = {
            experimental-features = [
                "nix-command" 
                "flakes" 
                "pipe-operators"
            ];

            allowed-users = [ "@wheel" ];
            trusted-users = [ "@wheel" ];

            warn-dirty = false;
            sandbox = true;
        };
    };

    environment.defaultPackages = lib.mkForce [];

    # automatic generation removing stuff
    # basically, remove up all generations before the previous commit,
    # plus an additional 4 generations
    #
    # theres the caveat that this runs after the bootloader is installed,
    # so the bootloader will show generations that don't actually exist
    system = rec {
        # i use the label to track what git commit the generation is associated with
        nixos.label = self.shortRev or self.dirtyShortRev;

        # inject nix-env and the current short hash for the script
        activationScripts.autoremove = ''
            NIX_ENV=${pkgs.nix}/bin/nix-env
            shorts=("${nixos.label}")
        '' + builtins.readFile ./autoremove.sh;
    };
}
