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
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "1G";
                            # sgdisk `efi partition` short code
                            type = "EF00";
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
                        main = {
                            size = "100%";
                            content = {
                                type = "luks";
                                name = "main-open";
                                content = {
                                    type = "zfs";
                                    pool = "zsystem";
                                };
				passwordFile = "/nix/persist/repos/secrets/password";
                            };
                        };
                    };
                };
            };
            # aux disks
            aux0 = {
                type = "disk";
                content = {
                    type = "gpt";
			# partlabels need to be `zfs`
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "aux0-open";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
				passwordFile = "/nix/persist/repos/secrets/password";
                        };
                    };
                };
            };
            aux1 = {
                type = "disk";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "aux1-open";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
				passwordFile = "/nix/persist/repos/secrets/password";
                        };
                    };
                };
            };
            aux2 = {
                type = "disk";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "aux2-open";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
				passwordFile = "/nix/persist/repos/secrets/password";
                        };
                    };
                };
            };
            aux3 = {
                type = "disk";
                content = {
                    type = "gpt";
                    partitions.main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "aux3-open";
                            content = {
                                type = "zfs";
                                pool = "zdata";
                            };
				passwordFile = "/nix/persist/repos/secrets/password";
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
                                "/dev/mapper/main-open"
                            ];
                        }
                    ];

                    # i dont have enough disks to take advantage of it, but zfs
                    # allows for "support vdevs", for tasks like logging and
                    # deduplicating
                };
		datasets = {
			"main" = {
				type = "zfs_fs";

				mountpoint ="/nix";
				# systemd is going to mount these, so we set the zfs mountpoint
				# to `legacy` so it doesn't attempt to mount in a race
				# condition
				options = {
					mountpoint = "legacy";
					canmount = "on";
				};
			};
		};
            };

            zdata = {
                type = "zpool";
                mode.topology = {
                    type = "topology";
                    vdev = [
                        {
                            mode = "raidz1";
                            members = [
                                "/dev/mapper/aux0-open"
                                "/dev/mapper/aux1-open"
                                "/dev/mapper/aux2-open"
                                "/dev/mapper/aux3-open"
                            ];
                        }
                    ];
                };

		datasets = {
			"main" = {
				type = "zfs_fs";

				mountpoint = "/srv/data0";
				options = {
					mountpoint = "legacy";
					canmount = "on";
				};
			};
		};
            };
        };
    };
}
