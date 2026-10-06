{
  # self,
  lib,
  ...
}: let
    #inherit (self.inputs) nixos-hardware;
in {
    #[see](https://guides.frame.work/Guide/NixOS+on+the+Framework+Laptop+13/400)
    imports = [
        ./hardware-configuration.nix
        # nixos-hardware.nixosModules.framework-13-7040-amd
    ];

    # add tuning to new "Framework Speakers" device
    # [see](https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/common/audio.nix)
    # hardware.framework.laptop13.audioEnhancement.enable = true;

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

            hardware.usb.enable = true;

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

