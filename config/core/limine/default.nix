{
    dots,
    pkgs,
    ...
}: let
    inherit (dots.inputs) wrappers;
in {
    dotfiles.self.forceEnable = true;

    # the limine installer hardcodes a check for `/var/lib/sbctl`, ignoring
    # the sbctl config, so point it at the persisted keys
    systemd.tmpfiles.rules = [
        "L+ /var/lib/sbctl - - - - /nix/persist/repos/secureboot"
    ];

    boot.loader = {
        timeout = 1;

        limine = {
            enable = true;

            maxGenerations = 20;

            secureBoot = {
                enable = true;
                sbctl = {
                    inherit pkgs;
                    package = pkgs.sbctl;

                    flags = let
                        sbctlConfig = builtins.toFile
                            "sbctlConfig"
                            ''
                                ---
                                keydir: /nix/persist/repos/secureboot
                                guid: /nix/persist/repos/secureboot/GUID
                                landlock: false
                            '';
                    in {
                        "--config" = sbctlConfig;
                    };
                }
                    |> wrappers.lib.wrapPackage
                ;
            };
        };
    };
}
