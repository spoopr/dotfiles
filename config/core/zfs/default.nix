{
    pkgs,
    lib,
    config,
    ...
}: {
    dotfiles.self.forceEnable = true;

    boot = {
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
    };
}
