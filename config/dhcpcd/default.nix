{
  ...
}: {
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
