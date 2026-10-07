{
  ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];

    system.stateVersion = "24.05";


    dotfiles = {
        core = {
            luks.enable = true;
        };

        system = {
            auth.users.spoopr.enable = true;

            network = {
                wpa_supplicant = {
                    options = {
                        wireless = {
                            enable = true;
                            detectInterfaces = true;
                        };

                        wired = {
                            enable = true;
                            detectInterfaces = true;
                        };
                    };
                };

                auth.university.enable = true;
                
                vpn = {
                    openvpn.enable = true;
                    wireguard.enable =true;
                };
            };

            audio.pipewire.enable = true;

            hardware = {
                usb.enable = true;

                keyd.options.capslockToAlt = true;

                fprintd.enable = true;
            };

            tools = {
                zsh.enable = true;
                ssh.enable = true;
            };
        };
    
        user = {
            ly.enable = true;
            niri.enable = true;
            mullvad.enable = true;
            firefox.enable = true;
            pass.enable = true;
            tor.enable = true;
            onlyoffice.enable = true;
            wireshark.enable = true;
            nvim.enable = true;
        };
    };
}

