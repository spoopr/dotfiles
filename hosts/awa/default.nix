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
        audit.enable = true;
        autoremove.enable = true;
        brightnessctl.enable = true;
        dhcpcd.enable = true;
        foot.enable = true;
        fwupd.enable = true;
        git.enable = true;
        grub.enable = true;
        impermanence.enable = true;
        iwd.enable = true;
        kernel.enable = true;
        lanzaboote.enable = true;
        luks.enable = true;
        ly.enable = true;
        mullvad.enable = true;
        network.enable = true;
        niri.enable = true;
        nix.enable = true;
        nvim.enable = true;
        openvpn.enable = true;
        pass.enable = true;
        pipewire.enable = true;
        ssh.enable = true;
        sudo.enable = true;
        swaylock.enable = true;
        tor.enable = true;
        usb.enable = true;
        users.enable = true;
        wireguard.enable =true;
        zsh.enable = true;
        zswap.enable = true;
    };
}

