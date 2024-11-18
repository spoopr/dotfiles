{
  pkgs,
  ...
}: {
  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  
    initrd.luks.devices = {
        root = {
          device = "/dev/nvme0n1p2";
          preLVM = true;
        };
      };
    

  };

  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/etc/nixos"
        "/srv"
        "/var/lib"
        "/var/log"
        "/etc/secureboot"
      ];
    };
  
    etc."machine-id".source = "/nix/persist/etc/machine-id";

  };

}
