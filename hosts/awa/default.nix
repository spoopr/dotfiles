{
  ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];

    system.stateVersion = "24.05";


    dotfiles = {
        audit.enable = false;
        grub.enable = true;
        luks.enable = true;
    };
}

