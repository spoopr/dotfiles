{
    dots,
    pkgs,
    ...
}: let
    inherit (dots.args) secrets;
    
    config = builtins.toFile
        "university.conf"
        ''
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
    script = pkgs.writeShellScript
        "ExecStart"
        /*
            2.             3. make readonly and transfer ownership to wpa_supplicant
        */
        ''
            # copy the file into wpa_supplicant's configuration folder
            ${pkgs.coreutils}/bin/cp ${config} /etc/wpa_supplicant/university.conf

            # read the contents of the (at runtime) decrypted secret files and
            # replace in the `.conf` file
            ${pkgs.gnugrep}/bin/grep \
                -o '/[^"]*' \
                /etc/wpa_supplicant/university.conf \
            | while read SECRET_PATH
            do
                # escape `&` symbols for `sed`
                SECRET_CONTENTS=$(sed "s|\&|\\\&|g" "$SECRET_PATH")

                ${pkgs.gnused}/bin/sed \
                    -i "s|$SECRET_PATH|$SECRET_CONTENTS|" \
                    /etc/wpa_supplicant/university.conf
            done
            unset SECRET_PATH SECRET_CONTENTS

            ${pkgs.coreutils}/bin/chmod 0440 /etc/wpa_supplicant/university.conf 
            ${pkgs.coreutils}/bin/chown root:wpa_supplicant /etc/wpa_supplicant/university.conf
        '';


in {
    dotfiles = {
        network = {
            wireless.enable = true;
            # wired.enable = true;
        };
    };

    networking.wireless.extraConfigFiles = [
        "/etc/wpa_supplicant/university.conf"
    ];

    systemd.services."wpa_supplicant_install_university" = {
        wantedBy = [
            "multi-user.target"
        ];

        before = [
            "wpa_supplicant.service"
        ];

        description = "WPA Supplicant configurator for `university` network";

        serviceConfig = {
            Type = "oneshot";

            ExecStart = "${script}";
        };
    };
}
