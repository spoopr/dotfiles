{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    iptables
  ];

  networking = {

    wireless.iwd = {
      enable = true;
      settings = {
	Network = {
	  EnableIPv6 = true;
	};
	General = {
	  AddressRandomization = "once";
	};
	Scan = {
	  DisablePeriodicScan = true;
	};
      };
    };
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
      allowedUDPPorts = [ 51820 ];
    };

    wg-quick.interfaces = {
      awa = {
        address = [ "10.2.0.2/32" ];
	dns = [ "10.2.0.1" ];
	listenPort = 51820;	

	privateKeyFile = config.age.secrets.awaPrivateKey.path; 

	postUp = "wg set awa fwmark 51820 && ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o awa -m mark ! --mark $(wg show awa fwmark) -m addrtype ! --dst-type LOCAL -j REJECT";
	preDown = "${pkgs.iptables}/bin/iptables -D OUTPUT ! -o awa -m mark ! --mark $(wg show awa fwmark) -m addrtype ! --dst-type LOCAL -j REJECT";

	peers = [
	  {
	    publicKey = "agoivyLoPqor8MxA/s6UWJSMcA2pMl+ajO3vy/q3oWQ=";
	    allowedIPs = [ "0.0.0.0/0" ];
	    endpoint = "103.125.235.18:51820";
	  }
	];
      };
    };

  };
}
