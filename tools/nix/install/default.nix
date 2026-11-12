{
    self,
    ...
}: let
    inherit (self.lib) shell;
in {
    flake.lib.install.mkInstaller = {
        pkgs,
        host,
        disks,
        repositories ? []
    }: let
        minimumRepositories = [
            "dotfiles"
            "secrets"
        ];

    in pkgs.writeShellApplication rec {
        name = "install-${host}";

        runtimeInputs = with pkgs; [
            disko
        ];

        text = ''
            NUMBER_DISKS=${builtins.length disks |> toString}
            DISKS=${shell.toArray disks}
            DISK_PATHS=("$@")
            COPIED_REPOS=${repositories ++ minimumRepositories |> shell.toArray}

            if [ "$EUID" -ne 0 ]; then
                echo "${name}: Disk operations require root permissions. Please run with sudo or as root."
                exit 1
            fi

            if [ "$#" -ne "$NUMBER_DISKS" ]; then
                echo "${name}: Host \`${host}\` requires $NUMBER_DISKS disk$([ "$NUMBER_DISKS" -gt 1 ] && echo 's') (''${DISKS[*]}), $# received."
                exit 1
            fi

            DISKO_ARGS="--mode format --flake .#${host}"
            for REPO in "''${COPIED_REPOS[@]}"; do
                DISKO_ARGS+=" --extra-files /nix/persist/repos/$REPO /nix/persist/repos/$REPO "
            done

            for INDEX in $(
                seq \
                    0 \
                    "$((NUMBER_DISKS - 1))"
            ); do
                DISKO_ARGS+=" --disk ''${DISKS[INDEX]} ''${DISK_PATHS[INDEX]} "
            done

            # shellcheck disable=SC2086
            exec disko-install $DISKO_ARGS
        '';
    };
}
