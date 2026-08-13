{
  ...
}: {
    dotfiles = {
        dhcpcd.enable = true;
        network.enable = true;
    };

    networking.wireless.iwd = {
        enable = true;
        settings = {
            Network.EnableIPv6 = false;
            General.AddressRandomization = "once";
            Scan.DisablePeriodicScan = true;
        };
    };
}
