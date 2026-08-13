{
  ...
}: {
    # i don't see why not to enable this
    dotfiles.self.forceEnable = true;

    boot.kernelModules = [
        # dhcpcd kernel modules
        "af_packet"
    ];

    networking.dhcpcd = {
        enable = true;
        extraConfig = ''
            anonymous
        '';
    };
}
