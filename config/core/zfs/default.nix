{
    pkgs,
    lib,
    config,
    ...
}: {
    dotfiles.self.forceEnable = true;

    boot = {
        # ripped [from](https://wiki.nixos.org/wiki/ZFS)
        kernelPackages = pkgs.linuxKernel.packages
            |> lib.filterAttrs (name: kernel:
                (builtins.match "linux_[0-9]+_[0-9]+" name) != null
                && (builtins.tryEval kernel).success
                && (!kernel.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
            )
            |> builtins.attrValues
            |> lib.sort (one: other:
                lib.versionOlder
                one.kernel.version
                other.kernel.version
            )
            |> lib.last;

        supportedFilesystems = [ "zfs" ];
        initrd.supportedFilesystems = [ "zfs" ];

        # on creation of a zpool with `disko`, the hostid is set to that of the
        # install media. you could manually update the hostid of a zpool after
        # creation, but zfs hostids are being deprecated anyways, so, eh.
        zfs = {
            forceImportAll = true;
            forceImportRoot = true;
        };
    };
}
