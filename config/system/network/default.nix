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
            backend = "iptables";

            extraCommands = ''
                iptables -A OUTPUT -m limit  --limit 5/min -j LOG --log-level 4
                iptables -A INPUT -m limit  --limit 5/min -j LOG --log-level 4
                iptables -A FORWARD -m limit  --limit 5/min -j LOG --log-level 4
            '';
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
                matchConfig.Name = "!wg* tun*";
                
                networkConfig = {
                    DHCP = "ipv4";
                    LinkLocalAddressing = "ipv4";
                    IPv6AcceptRA = "no";
                };
            };
        };
    };
}
