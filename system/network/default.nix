{
  ...
}: {
    imports = [
        ./openvpn
        ./wireguard
    ];

    boot.kernelModules = [
        # dhcpcd kernel modules
        "af_packet" 
        # usb ethernet modules
        "usbnet"
        "cdc_ether"
        "cdc_mbim"
        "cdc_wdm"
        "cdc_ncm"
    ];

    networking = {
        enableIPv6 = false;

        wireless.iwd = {
            enable = true;
            settings = {
                Network.EnableIPv6 = false;
                General.AddressRandomization = "once";
                Scan.DisablePeriodicScan = true;
            };
        };
        /*
        networkmanager = {
            enable = true;

            wifi = {
                macAddress = "random";
                powersave =  true;
            };
            ethernet.macAddress = "random";

            dhcp = "dhcpcd";

            settings = {
                ipv4 = {
                    "dhcp-send-hostname" = "false";
                };
                ipv6 = {
                    "dhcp-send-hostname" = "false";
                };
            };
        };
        */
        dhcpcd = {
            enable = true;
            extraConfig = ''
                anonymous
            '';
        };

        firewall = {
            enable = true;
            allowPing = false;
            logReversePathDrops = true;
        };
    };
}
