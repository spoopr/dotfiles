{
  ...
}: {
    boot = {
        loader.efi.canTouchEfiVariables = true;

        initrd = {
            # this is required for unattended luks unlock
            systemd.enable = true;

            luks.devices = {
                root = {
                    device = "/dev/nvme0n1p2";
                    preLVM = true;
                };
            };
        };
    };
}
