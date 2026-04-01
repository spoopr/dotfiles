{
  ...
}: {
    networking = {
        enableIPv6 = false;

        firewall = {
            enable = true;
            allowPing = false;
            logReversePathDrops = true;
        };
    };
}
