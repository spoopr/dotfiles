{
  # self,
  ...
}: let
    #inherit (self.inputs) nixos-hardware;
in {
    #[see](https://guides.frame.work/Guide/NixOS+on+the+Framework+Laptop+13/400)
    imports = [
        ./hardware-configuration.nix
        # nixos-hardware.nixosModules.framework-13-7040-amd
    ];

    # add tuning to new "Framework Speakers" device
    # [see](https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/common/audio.nix)
    # hardware.framework.laptop13.audioEnhancement.enable = true;

    system.stateVersion = "24.05";


    dotfiles = {
        # hardware / usage
        luks.enable = true;
        users.spoopr.enable = true;

        # utilities
        iwd.enable = true;
        openvpn.enable = true;
        wireguard.enable =true;

        pipewire.enable = true;
        usb.enable = true;

        zsh.enable = true;
        ssh.enable = true;
        nvim.enable = true;

        # apps
        ly.enable = true;
        niri.enable = true;
        mullvad.enable = true;
        pass.enable = true;
        tor.enable = true;
        onlyoffice.enable = true;
        wireshark.enable = true;
    };
}

