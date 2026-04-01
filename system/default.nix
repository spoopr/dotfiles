{
  ...
}: {
    imports = [
        ./audit
        ./autoremove
        ./dhcpcd
        ./fwupd
        ./grub
        ./impermanence
        ./iwd
        ./kernel
        ./lanzaboote
        ./luks
        ./network
        ./nix
        ./openvpn
        ./pipewire
        ./sudo
        ./usb
        ./users
        ./wireguard
        ./zswap
        ./git
        ./ssh
    ];

    time.timeZone = "America/Chicago";
}
