{
  lib,
  ...
}: {
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

            substituters = [
                "https://cache.nixos.org"
            ];
            trusted-public-keys = [
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
        };
    };

    environment.defaultPackages = lib.mkForce [];
}
