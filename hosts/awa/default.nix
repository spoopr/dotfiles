{
  ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];

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

