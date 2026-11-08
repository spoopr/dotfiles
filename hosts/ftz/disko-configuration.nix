{
    ...
}: {
    disko.devices = {
        # disko uses `/dev/disk/by-id`, with the id's generated based on the
        # disk and partition name.
        #
        # because of that, if `ftz` is used on a system that was partitioned by
        # disko with similar naming, it'll collide and possible import the
        # in-device disk rather than the one `ftz`` is installed on.
        #
        # thus, we get `portable` for the disk, and `live` for the partition.
        disk.portable = {
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    boot = {
                        size = "1G";
                        type="EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                        };
                    };

                    swap = {
                        size = "32G";
                        content = {
                            type = "swap";
                            randomEncryption = true;
                        };
                    };

                    live = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "live-open";
                            content = {
                                type = "zfs";
                                pool = "zportable";
                            };
                            passwordFile = "/nix/persist/repos/secrets/password";
                        };
                    };
                };
            };
        };

        nodev."/" = {
            fsType = "tmpfs";
            mountOptions = [
                "size=1G"
                "mode=755"
            ];
        };

        zpool.zportable = {
            type = "zpool";

            mode.topology = {
                type = "topology";
                vdev = [
                    {
                        mode = "";
                        members = [
                            "/dev/mapper/live-open"
                        ];
                    }
                ];
            };

            datasets."live" = {
                type = "zfs_fs";
                mountpoint ="/nix";
                options.mountpoint = "legacy";
            };
        };
    };
}
