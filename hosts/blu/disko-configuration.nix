{
    ...
}: {
    disko.devices = {
        # configure all the physical drives
        #
        # except for the system nvme, for each disk this is basically just says
        # "fill with luks, then assign the decrypted section to a zpool"
        disk = {
            # the system nvme gets a second, unencrypted partition for booting
            system = {
                type = "disk";
                device = "/dev/disk/by-uuid/blah";
                content = {
                    type = "gpt";
                    partitions = {
                        boot = {
                            size = "1G";
                            # sgdisk `efi partition` short code
                            type = "EF00";
                            content = {
                                type = "filesystem";
                                format = "ext4";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        system = {
                            size = "100%";
                            content = {
                                type = "luks";
                                name = "system";
                                content = {
                                    type = "zfs";
                                    pool = "zsystem";
                                };
                            };
                        };
                    };
                };
            };
            # aux disks
            UL = {
                type = "disk";
                device = "/dev/disk/by-uuid/bleh";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "UL";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
                        };
                    };
                };
            };
            UR = {
                type = "disk";
                device = "/dev/disk/by-uuid/bluh";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "UR";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
                        };
                    };
                };
            };
            LL = {
                type = "disk";
                device = "/dev/disk/by-uuid/blih";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "LL";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
                        };
                    };
                };
            };
            LR = {
                type = "disk";
                device = "/dev/disk/by-uuid/bloh";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "LR";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
                        };
                    };
                };
            };
        };

        # since we're using an impermanence setup, create a tmpfs for `/`
        nodev."/" = {
            fsType = "tmpfs";
            mountOptions = [
                "size=8G"
                "mode=755"
            ];
        };

        # configure all the zpools
        zpool = {
            zsystem = {
                type = "zpool";
                # disko allows for zfs to be configured as though its simply one
                # vdev, and will abstract away everything else. to use that
                # feature, just enter the vdev type in place of `mode`.
                #
                # but, i wanna control all the vdevs
                mode.topology = {
                    type = "topology";
                    vdev = [
                        {
                            # no mode, cause only one drive
                            mode = "";
                            members = [
                                "system"
                            ];
                        }
                    ];

                    # i dont have enough disks to take advantage of it, but zfs
                    # allows for "support vdevs", for tasks like logging and
                    # deduplicating
                };
            };

            zdata = {
                type = "zpool";
                mode.topology = {
                    type = "topology";
                    vdev = [
                        {
                            mode = "zraid1";
                            members = [
                                "UL"
                                "UR"
                                "LL"
                                "LR"
                            ];
                        }
                    ];
                };
            };
        };
    };
}
