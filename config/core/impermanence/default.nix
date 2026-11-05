{
  dots,
  lib,
  cfg,
  options,
  ...
}: {
    dotfiles.self = {
        options.paths = lib.mkOption {
            # it would be better to pull impermanence's option type, but its
            # submodule so its messy to do so
            type = with lib.types; {
                inStore = false;
                absolute = true;
            }
                |> pathWith
                |> either attrs
                |> listOf;
            default = [];
        };
        
        forceEnable = true;
    };

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
            directories = cfg.options.paths
                ++ [
                "/etc/nixos"
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
