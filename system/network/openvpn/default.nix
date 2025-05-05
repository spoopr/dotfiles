{
  pkgs,
  lib,
  secrets,
  ...
}: let
  mkService = name: { config, auth }: {
    description = ''OpenVPN for ${lib.strings.removePrefix "openvpn-" name}'';

    path = with pkgs; [
      iptables
      iproute2
      nettools
    ];
    
    serviceConfig = {
      ExecStart = "@${pkgs.openvpn}/bin/openvpn --suppress-timestamps --config ${config} --auth-user-pass ${auth} --up ${./update-resolv-conf} --down ${./update-resolv-conf}";
      Restart = "always";
      Type = "notify";
    };
  };

in {

  boot.kernelModules = [ "tun" ];

  systemd.services = builtins.mapAttrs mkService {
    "openvpn-awa" = {
      config = secrets.vpn.openvpn."awa.tcp.ovpn";
      auth = secrets.vpn.openvpn.spoopr; 
    };
  };
}
