{
    ...
}: {
    disko.devices = {
        disk.system = {
            type = "disk";
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
                    size = "64G";
                    content = {
                        type = "swap";
                        randomEncryption = true;
                    };
                };
 
                main = {
                    size = "100%";
                    content = {
                        type = "luks";
                        name = "main-open";
                        content = {
                            type = "zfs";
                            pool = "zsystem";
                        };
                    };
                };
            };
        };

        nodev."/" = {
            fsType = "tmpfs";
            mountOptions = [
                "size=32G"
                "mode=755"
            ];
        };

        # implicitly, there's up to 768G of space available for ad-hoc zvols
        zpool.zsystem = {
            type = "zpool";

            mode.topology = {
                type = "topology";
                vdev = [
                    {
                        mode = "";
                        members = [
                            "/dev/mapper/main-open"
                        ];
                    }
                ];
            };

            datasets."main" = {
                type = "zfs_fs";

                mountpoint ="/nix";

                options = {
                    reservation = "256G";
                    mountpoint = "legacy";
                    canmount = "on";
                };
            };
        };
    };
}
