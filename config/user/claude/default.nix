{
    pkgs,
    lib,
    dots,
    ...
}: let
    inherit (dots.inputs) wrappers;
in {
    dotfiles = {
        system.nix.unfree.enable = true;

        core.impermanence.options.paths = [
            {
                directory = "/var/lib/claude-code/memory";
                user = "spoopr";
                group = "users";
                mode = "700";
            }
        ];
    };

    environment.systemPackages = {
        inherit pkgs;
        package = pkgs.claude-code;

        env = {
            CLAUDE_CONFIG_DIR = "/nix/persist/repos/claude";
        };
    }
        |> wrappers.lib.wrapPackage
        |> lib.singleton
    ;

    environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
        autoMemoryDirectory = "/var/lib/claude-code/memory";
    };
}
