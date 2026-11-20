{
    lib,
    config,
    ...
}: {
    services.pipewire = {
        enable = true;
        alsa = {
            enable = true;
            support32Bit = true;
        };
        pulse.enable = true;
        
        wireplumber = {
            extraConfig = {
                "20-default-silent" = {
                    "wireplumber.settings" = {
                        "device.routes.default-sink-volume" = 0.0;
                    };
                };

                "10-bluez" = lib.mkIf
                    config.dotfiles.system.hardware.bluetooth.enable
                    {
                        "monitor.bluez.properties" = {
                            "bluez5.enable-sbc-xq" = true;
                            "bluez5.enable-msbc" = true;
                            "bluez5.enable-hw-volume" = true;
                            "bluez5.roles" = [
                                "a2dp_source"
                                "bap_source"
                            ];
                        };
                    };
            };
        };
    };

    security.rtkit.enable = true;
}
