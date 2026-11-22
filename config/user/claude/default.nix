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
        "themes"
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

    users.groups.claude.members = [
        "spoopr"
    ];

    # tmpfiles applies ownership to the symlinks themselves (mode is ignored)
    systemd.tmpfiles.rules = configFiles
        |> map (file: "L+ ${stateDir}/${file} - root claude - ${configRepo}/${file}")
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

    # without this, memory defaults to `${stateDir}/projects/<cwd>/memory/`:
    # one directory per working directory, so memories don't carry across
    # projects, and they're scattered inside the state dir instead of living in
    # a single private repo
    environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
        autoMemoryDirectory = "${stateDir}/memory";
    };
}
