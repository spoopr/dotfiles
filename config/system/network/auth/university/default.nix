{
    dots,
    pkgs,
    ...
}: let
    inherit (dots.args) secrets;
in {
    dotfiles = {
        system.network.auth.options = {
            wireless.university = ''
                network={
                    ssid="${secrets.networks.university.ssid}"
                    key_mgmt=WPA-EAP
                    eap=PEAP
                    identity="${secrets.networks.university.identity}"
                    password="${secrets.networks.university.password}"
                    phase2="autheap=MSCHAPV2"
                    disabled=1
                }
            '';
            wired.university = ''
                network={
                    key_mgmt=IEEE8021X
                    eap=PEAP
                    identity="${secrets.networks.university.identity}"
                    password="${secrets.networks.university.password}"
                    phase2="autheap=MSCHAPV2"
                    disabled=1
                }
            '';
        };
    };
}
