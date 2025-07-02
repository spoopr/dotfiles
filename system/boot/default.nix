{
  pkgs,
  ...
}: {  
    imports = [
        ./zswap
        ./lanzaboote
    ];

    boot = {
        loader = {
            timeout = 0;
            efi.canTouchEfiVariables = true;
        };

        initrd = {
            # this is required for unattended luks unlock
            systemd.enable = true;

            luks.devices = {
                root = {
                    device = "/dev/nvme0n1p2";
                    preLVM = true;
                };
            };
        };

        tmp = {
            cleanOnBoot = true;
            useTmpfs = true;
        };

    };

    environment = {
        persistence."/nix/persist" = {
            directories = [
                "/etc/nixos"
                "/srv"
                "/var/lib"
                "/var/log"
            ];
        };

        etc."machine-id".source = "/nix/persist/etc/machine-id";
    };
}
