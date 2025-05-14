{
  ...
}: {
	imports = [
		./openvpn
		./wireguard
	];

	# dhcpcd kernel modules
	boot.kernelModules = [
		"af_packet"	
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
