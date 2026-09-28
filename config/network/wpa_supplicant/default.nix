# cause the nixpkgs one sucks for ethernet support. also, its setup such that
# each interface gets its own `wpa_supplicant` instance which messes with
# `wpa_cli`; this generates one instance for all interfaces
#
# okay but to be fair i did rip a lot of code from it, im lazy, so
# [credit](https://github.com/NixOS/nixpkgs/blob/c27cdad491a991b11ed731760aa2ef8db0cb0410/nixos/modules/services/networking/wpa_supplicant.nix)
{
    config,
    cfg,
    lib,
    pkgs,
    ...
}: {
    dotfiles.self = {
        forceEnable = cfg.options.wired.enable
            || cfg.options.wireless.enable;

        options = let
            configFilesOption = lib.mkOption {
                type = with lib.types; listOf path;
                default = [];
            };
            

            interfaceGroup = name: drivers: {
                enable = lib.mkEnableOption "wpa_supplicant.${name}";

                # config global to intreface group
                configFiles = configFilesOption;

                # interfaces will be automatically scanned later (if enabled), just
                # in case you want to preset some
                interfaces = lib.mkOption {
                    type = with lib.types; {
                        configFiles = configFilesOption;
                        drivers = lib.mkOption {
                            type = listOf str;
                            default = drivers;
                        };
                    }
                        |> lib.attrsets.setAttrByPath [ "options" ]
                        |> submodule
                        |> attrsOf;

                    default = {};
                };

                detectInterfaces = lib.mkEnableOption "wpa_supplicant.${name}.detectInterfaces";
            };
        in {
            # global config
            configFiles = configFilesOption;

            wired = interfaceGroup
                "wired"
                [ "wired" ];

            wireless = interfaceGroup
                "wireless"
                [ "nl80211" "wext" ];
        };
    };


    systemd.services."wpa_supplicant" = let
        toExtraConfigArgs = files: files
            |> map (x: "-I ${x}")
            |> builtins.concatStringsSep " ";

        # array element checking in the script pads each item with spaces to
        # prevent substring matching, so we need to pad how we create the
        # arrays too
        toArray = list: list
            |> builtins.concatStringsSep "\" \""
            |> (x: "( \" ${x} \" )");

        assemblePresets = attrs: attrs.interfaces
            |> lib.mapAttrsToList (name: value:
                "-i ${name} -c /etc/wpa_supplicant/required.conf -D ${builtins.concatStringsSep "," value.drivers} ${toExtraConfigArgs value.configFiles}"
            )
            |> map (x: x
                + " ${toExtraConfigArgs cfg.options.configFiles}"
                + " ${toExtraConfigArgs attrs.configFiles}"
            )
            |> toArray;

    in {
        description = "bottlecap wpa_supplicant instance";

        before = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        # this entire chunk was just yanked from the nixos version
        serviceConfig = {
            RuntimeDirectory = "wpa_supplicant";

            User = "wpa_supplicant";
            Group = "wpa_supplicant";

            AmbientCapabilities = [
                "CAP_NET_ADMIN"
                "CAP_NET_RAW"
            ];

            CapabilityBoundingSet = [
                "CAP_NET_ADMIN"
                "CAP_NET_RAW"
            ];

            RootDirectory = "/run/wpa_supplicant";
            RootDirectoryStartOnly = true;

            BindPaths = [
                "/etc/wpa_supplicant" # to write wpa_supplicant.conf{,.tmp}
                "/run/wpa_supplicant" # to make control sockets
                # to set up interfaces
                "/proc/sys/net"
                "/dev/rfkill"
            ];

            DeviceAllow = "/dev/rfkill rw";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateMounts = true;
            PrivateTmp = true;
            PrivateUsers = false;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            IPAddressDeny = "any";
            RemoveIPC = true;
            RestrictAddressFamilies = [
                "AF_UNIX"
                "AF_INET"
                "AF_INET6"
                "AF_NETLINK"
                "AF_PACKET"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallFilter = [
                "@system-service"
                "~@keyring"
                "~@resources"
            ];
            SystemCallArchitectures = "native";
            UMask = "0077";
        };


        path = with pkgs; [
            wpa_supplicant
            coreutils
        ];

        script = ''
            # setup user control sockets
            mkdir -p /run/wpa_supplicant/client
            chown wpa_supplicant:wpa_supplicant /run/wpa_supplicant/client
            chmod g=u /run/wpa_supplicant/client

            # find interfaces
            INTERFACES=($(\
                find -H /sys/class/net/* \
                    -name "type" \
                    -exec grep -l '^1$' {} + \
                | xargs -- dirname \
            ))

            declare -a WIRED
            declare -a WIRELESS

            # due to the nature of this service, we're inevitably gonna have
            # to restart it as the interfaces change, for example, if i plugin
            # a usb ethernet adapter. so, don't wait for interfaces to show,
            # just assume that's what we have
            for INTERFACE in "''${INTERFACES[@]}"; do
                if [ -n "$(find -H "$INTERFACE" -name 'wireless')" ]; then
                    WIRELESS+=("$(basename $INTERFACE)")
                else
                    WIRED+=("$(basename $INTERFACE)")
                fi
            done

            # for exclusion later
            PRESET_WIRED=${cfg.options.wired.interfaces |> builtins.attrNames |> toArray}
            PRESET_WIRELESS=${cfg.options.wireless.interfaces |> builtins.attrNames |> toArray}


            # assemble  args
            ARGLINES=()
            
            if ${if cfg.options.wired.enable then "true" else "false"}; then
                ARGLINES+=${assemblePresets cfg.options.wired}

                if ${if cfg.options.wired.detectInterfaces then "true" else "false"}; then
                    for INTERFACE in "''${WIRED[@]}"; do
                        # don't make again if it was already a preset
                        if [[ ! "''${PRESET_WIRED[@]}" =~ "  $INTERFACE " ]]; then
                            # always use `required.conf` and the global option files
                            ARGLINES+=( "-i $INTERFACE -D wired -c /etc/wpa_supplicant/required.conf ${toExtraConfigArgs cfg.options.configFiles} ${toExtraConfigArgs cfg.options.wired.configFiles}" )
                        fi
                    done
                fi
            fi

            if ${if cfg.options.wireless.enable then "true" else "false"}; then
                ARGLINES+=${assemblePresets cfg.options.wireless}

                if ${if cfg.options.wireless.detectInterfaces then "true" else "false"}; then
                    for INTERFACE in "''${WIRELESS[@]}"; do
                        if [[ ! "''${PRESET_WIRELESS[@]}" =~ " $INTERFACE " ]]; then
                            ARGLINES+=( "-i $INTERFACE -D nl80211,wext -c /etc/wpa_supplicant/required.conf ${toExtraConfigArgs cfg.options.configFiles} ${toExtraConfigArgs cfg.options.wireless.configFiles}" )
                        fi
                    done
                fi
            fi

            # log to syslog
            ARGS="-s "

            ARGS+=$(IFS=" -N " echo "''${ARGLINES[@]}")


            # start daemon
            echo "$ARGS"
            exec wpa_supplicant $ARGS
        '';
    };

    users = {
        groups.wpa_supplicant = {};
        users.wpa_supplicant = {
            isSystemUser = true;
            group = "wpa_supplicant";
        };
    };

    environment = {
        # while this serves to place the `required.conf` file, it also pulls
        # double duty to create the `/etc/wpa_supplicant` directory
        etc."wpa_supplicant/required.conf".text = ''
            # disable scanning
            bgscan=""
        '';

        systemPackages = with pkgs; [
            wpa_supplicant
        ];
    };

    assertions = [
        {
            assertion = !config.networking.wireless.enable;
            message = ''
                i made this module to replace 'networking.wireless', so the
                two'll conflict.
            '';
        }
        {
            assertion = cfg.options.wireless.enable || cfg.options.wired.enable;
            message = ''
                this service has neither wireless nor wired capabilities
                enabled, thus will not do anything at all.
            '';
        }
    ];
}
