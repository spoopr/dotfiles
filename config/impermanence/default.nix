{
  dots,
  ...
}: {
    imports = with dots.inputs; [
        impermanence.nixosModules.impermanence
    ];


    boot = {
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
                    "/var/lib/nixos"
                    "/var/lib/systemd"
                    "/var/log"
            ];
        };

        etc."machine-id" = {
            text = "b08dfa6083e7567a1921a715000001fb";
        };
    };
}
