{
    ...
}: {
    networking.wireless = {
        enable = true;
        userControlled = true;
    };

    systemd.network = {
        networks = {
            "20-wlp1s0" = {
                matchConfig.Name = "wlp1s0";
            };
        };
    }; 
}
