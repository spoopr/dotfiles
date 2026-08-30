{
  ...
}: {
    dotfiles.self.forceEnable = true;

    boot.kernelModules = [
        "ccm"
        "cmac"
    ];

    networking = {
        # protonvpns mostly only support ipv4 for now
        enableIPv6 = false;

        firewall = {
            enable = true;
            allowPing = false;
            logReversePathDrops = true;
        };

        # override conflicting defaults
        useDHCP = false;
        useNetworkd = true;
    };

    systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
    systemd.network = {
        enable = true;

        networks = {
            "10-disable-ipv6" = {
                matchConfig.Kind = "!wireguard";
                
                networkConfig = {
                    DHCP = "ipv4";
                    LinkLocalAddressing = "ipv4";
                    IPv6AcceptRA = "no";
                };
            };
        };
    };
}
