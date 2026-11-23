{
    pkgs,
    lib,
    dots,
    ...
}: let
    inherit (dots.inputs) wrappers;

    # <!-- claude -->
    # runtime state (credentials, history, transcripts, plugins, jobs) is
    # private and lives here; `memory/` inside it is its own private repo
    # <!-- /claude -->
    stateDir = "/var/lib/claude-code";

    # <!-- claude -->
    # the public repo only holds configuration, linked into the state dir
    # <!-- /claude -->
    configRepo = "/nix/persist/repos/claude";
    configFiles = [
        "settings.json"
        "keybindings.json"
        "CLAUDE.md"
        "skills"
        "themes"
    ];
in {
    dotfiles = {
        system.nix.unfree.enable = true;

        # <!-- claude -->
        # impermanence only applies these when it creates the persisted source
        # directory, so changing them needs a manual chown/chmod of
        # /nix/persist${stateDir}
        # <!-- /claude -->
        core.impermanence.options.paths = [
            {
                directory = stateDir;
                user = "root";
                group = "claude";
                mode = "770";
            }
        ];
    };

    users.groups.claude.members = [
        "spoopr"
    ];

    # <!-- claude -->
    # tmpfiles applies ownership to the symlinks themselves (mode is ignored)
    # <!-- /claude -->
    systemd.tmpfiles.rules = configFiles
        |> map (file: "L+ ${stateDir}/${file} - spoopr claude - ${configRepo}/${file}")
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

    # <!-- claude -->
    # without this, memory defaults to `${stateDir}/projects/<cwd>/memory/`:
    # one directory per working directory, so memories don't carry across
    # projects, and they're scattered inside the state dir instead of living in
    # a single private repo
    # <!-- /claude -->
    environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
        autoMemoryDirectory = "${stateDir}/memory";
    };
}
