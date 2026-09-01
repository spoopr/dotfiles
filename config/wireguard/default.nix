{
  dots,
  pkgs,
  ...
}: let
    inherit (dots.args) secrets;
in {
    dotfiles = {
        args.secrets.enable = true;
        
        network.enable = true;
    };

    # see `man systemd.netdev`
    age.secrets."wireguard" = {
        file = /nix/persist/repos/secrets/hosts/awa/vpn/wireguard/awa.age;
        mode = "0440";
        owner = "root";
        group = "systemd-network";
    };

    boot.kernelModules = [
        "wireguard"
        "xt_addrtype"
        "xt_comment"
        "xt_mark"
        "xt_connmark"
        "xt_conntrack"
    ];

    environment.systemPackages = with pkgs; [
        wireguard-tools
    ];

    networking.firewall = {
        allowedUDPPorts = [ 51820 ];
        checkReversePath = "loose";
    };

    systemd.network = {
        networks."50-wg0" = {
            matchConfig.Name = "wg0";
            
            address = [ "10.2.0.2/32" ];

            domains = [ "~." ];
            dns = [ "10.2.0.1" ];
            networkConfig.DNSDefaultRoute = true;


            routingPolicyRules = [
                {
                    Family = "ipv4";
                    InvertRule = true;
                    FirewallMark = 51820;
                    Table = 1000;
                    Priority = 10;
                }
                {
                    To = "185.159.156.37/32";
                    Table = "main";
                    Priority = 5;
                }
            ];
        };

        netdevs."50-wg0" = {
             netdevConfig = {
                 Kind = "wireguard";
                 Name = "wg0";
             };

             wireguardConfig = {
                ListenPort = 51820;
                PrivateKeyFile = "/run/agenix/wireguard";
                FirewallMark = 51820;
             };

             wireguardPeers = [
                {
                    PublicKey = "7FslkahrdLwGbv4QSX5Cft5CtQLmBUlpWC382SSF7Hw=";
                    AllowedIPs = [ "0.0.0.0/0" ];
                    Endpoint = "185.159.156.37:51820";
                    RouteTable = 1000;
                }
             ];
        };

        wait-online.ignoredInterfaces = [ "wg0" ];
    };
}
