{
    lib,
    ...
}: {
    imports = [
        ./disko-configuration.nix
    ];

    dotfiles = {
        system.network.wpa_supplicant.options = {
            wireless = {
                enable = true;
                detectInterfaces = true;
            };
            wired = {
                enable = true;
                detectInterfaces = true;
            };
        };

        user.nvim.enable = true;
    };

    users.users.root.password = lib.mkForce "toor";

    # normally set by hardware-configuration.nix, but of course there isn't one
    nixpkgs.hostPlatform = "x86_64-linux";

    boot = {
        supportedFilesystems = [
            "ext4"
            "vfat"
        ];

        initrd.availableKernelModules = [
            "usb_storage"
            "xhci_pci"
            "thunderbolt"
        ];

        loader.efi.canTouchEfiVariables = true;
        loader.systemd-boot.enable = true;
    };

    networking.hostId = "9f0e18d7";

    system.stateVersion = "26.11";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;
}
