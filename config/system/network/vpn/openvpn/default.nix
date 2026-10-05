{
  pkgs,
  lib,
  dots,
  ...
}: let
    inherit (dots.inputs) wrappers;
in {
    boot.kernelModules = [ "tun" ];

    networking.firewall.allowedUDPPorts = [ 1337 ];

    environment.systemPackages = {
        inherit pkgs;
        package = pkgs.openvpn;

        flags."--config" = ./disable-ipv6.conf;
    }
        |> wrappers.lib.wrapPackage
        |> lib.singleton;
}
