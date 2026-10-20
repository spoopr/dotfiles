{
  lib,
  ...
}: {
    dotfiles.self.forceEnable = true;

    nix = {
        settings = {
            experimental-features = [
                "nix-command"
                "flakes"
                "pipe-operators"
                "ca-derivations"
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

            # fuck it
            # full send builds
            cores = 0;
            max-jobs = 4;
            keep-going = true;
        };

        channel.enable = false;

        registry = {
            "templates" = {
                from = {
                    type = "indirect";
                    # `nix flake init` uses the default template
                    # `templates#default`, so this reroutes to my own personal
                    # template.
                    id = "templates";
                };

                to = {
                    type = "github";
                    owner = "spoopr";
                    repo = "flake-templates";
                };
            };
        };
    };

    environment.defaultPackages = lib.mkForce [];

    # add development man/info/other pages
    documentation.dev.enable = true;
}
