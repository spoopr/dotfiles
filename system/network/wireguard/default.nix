{
  pkgs,
  config,
  ...
}: {

  boot.kernelModules = [
    "wireguard" 
    "xt_addrtype"
    "xt_comment"
    "xt_mark"
    "xt_connmark"
    "xt_conntrack"
    "ipt_REJECT"
  ];

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];

    wg-quick.interfaces = {
      awa = {
	autostart = false;

        address = [ "10.2.0.2/32" ];
	dns = [ "10.2.0.1" ];
	listenPort = 51820;	

	privateKeyFile = config.age.secrets.awaPrivateKey.path; 

	postUp = "wg set awa fwmark 51820 && ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o awa -m mark ! --mark $(wg show awa fwmark) -m addrtype ! --dst-type LOCAL -j REJECT";
	preDown = "${pkgs.iptables}/bin/iptables -D OUTPUT ! -o awa -m mark ! --mark $(wg show awa fwmark) -m addrtype ! --dst-type LOCAL -j REJECT";

	peers = [
	  {
	    publicKey = "7FslkahrdLwGbv4QSX5Cft5CtQLmBUlpWC382SSF7Hw=";
	    allowedIPs = [ "0.0.0.0/0" ];
	    endpoint = "185.159.156.37:51820";
	  }
	];
      };
    }; 
  };
}
