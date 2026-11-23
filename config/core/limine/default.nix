{
    dots,
    pkgs,
    ...
}: let
    inherit (dots.inputs) wrappers;
in {
    dotfiles.self.forceEnable = true;

    # <!-- claude -->
    # the limine installer hardcodes an existence check for `/var/lib/sbctl`,
    # ignoring the sbctl config, so create it to satisfy the check
    # <!-- /claude -->
    systemd.tmpfiles.rules = [
        "d /var/lib/sbctl 0700 root root -"
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
