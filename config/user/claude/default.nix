{
    pkgs,
    lib,
    dots,
    ...
}: let
    inherit (dots.inputs) wrappers;

    # runtime state (credentials, history, transcripts, plugins, jobs) is
    # private and lives here; `memory/` inside it is its own private repo
    stateDir = "/var/lib/claude-code";

    # the public repo only holds configuration, linked into the state dir
    configRepo = "/nix/persist/repos/claude";
    configFiles = [
        "settings.json"
        "CLAUDE.md"
        "skills"
    ];
in {
    dotfiles = {
        system.nix.unfree.enable = true;

        core.impermanence.options.paths = [
            {
                directory = stateDir;
                user = "spoopr";
                group = "users";
                mode = "700";
            }
        ];
    };

    systemd.tmpfiles.rules = configFiles
        |> map (file: "L+ ${stateDir}/${file} - - - - ${configRepo}/${file}")
    ;

    environment.systemPackages = {
        inherit pkgs;
        package = pkgs.claude-code;

        env = {
            CLAUDE_CONFIG_DIR = stateDir;
        };
    }
        |> wrappers.lib.wrapPackage
        |> lib.singleton
    ;

    environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
        autoMemoryDirectory = "${stateDir}/memory";
    };
}
