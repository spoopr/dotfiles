{
    lib,
    cfg,
    pkgs,
    ...
}: let
    mkScript = name: configPath: (pkgs.writeShellScript
        "${name}-ExecStart"
        ''
            # copy the file into wpa_supplicant's configuration folder
            ${pkgs.coreutils}/bin/cp ${configPath} /etc/wpa_supplicant/${name}.conf

            # read the contents of the (at runtime) decrypted secret files and
            # replace in the `.conf` file
            ${pkgs.gnugrep}/bin/grep \
                -o '/[^"]*' \
                /etc/wpa_supplicant/${name}.conf \
            | while read SECRET_PATH
            do
                # escape `&` symbols for `sed`
                SECRET_CONTENTS=$(sed "s|\&|\\\&|g" "$SECRET_PATH")

                ${pkgs.gnused}/bin/sed \
                    -i "s|$SECRET_PATH|$SECRET_CONTENTS|" \
                    /etc/wpa_supplicant/${name}.conf
            done
            unset SECRET_PATH SECRET_CONTENTS

            # make readonly and transfer ownership to wpa_supplicant
            ${pkgs.coreutils}/bin/chmod 0440 /etc/wpa_supplicant/${name}.conf
            ${pkgs.coreutils}/bin/chown root:wpa_supplicant /etc/wpa_supplicant/${name}.conf
        ''
    );
in {
    dotfiles.self = {
        options = lib.mkOption {
            default = {};
            type = lib.types.attrsOf lib.types.str;
            
            description = ''
                Define an additional network config file for wpa_supplicant.
                Any paths in the file will have their contents read and
                replaced at runtime, allowing for nix-style secrets to be used.
            '';
        };

        forceEnable = cfg.options != {};
    };

    networking.wireless.extraConfigFiles = cfg.options
        |> builtins.attrNames
        |> map (x: "/etc/wpa_supplicant/${x}.conf");

    systemd.services = lib.attrsets.concatMapAttrs
        (name: value: let
            config = builtins.toFile
                "${name}.conf"
                value;
        in {
            "wpa_supplicant_install_${name}" = {
                    wantedBy = [
                        "wpa_supplicant.service"
                    ];

                    before = [
                        "wpa_supplicant.service"
                    ];

                    description = "WPA Supplicant configurator for `${name}` network";

                    serviceConfig = {
                        Type = "oneshot";

                        ExecStart = "${mkScript name config}";
                    };
            };
        })
        cfg.options;
}
