{
  pkgs,
  colors,
  ...
}: let

    wrapperlandConfig = builtins.toFile "wrapperlandConfig" (''
        $primaryColor = rgb(${colors.lavendar.hexNoHash})
        $secondaryColor = rgb(${colors.black.hexNoHash})

        source=${./input.conf}
        source=${./meta.conf}
        source=${./general.conf}
        source=${./setup.conf}
    ''
    );

    wrapperland = (pkgs.symlinkJoin {
        name = "wrappedHyprland";
        paths = [ pkgs.hyprland ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
        wrapProgram $out/bin/Hyprland --add-flags "-c ${wrapperlandConfig}"
        '';
    });

in {

    environment.systemPackages = [
        wrapperland 
    ];

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ 
            xdg-desktop-portal-gtk
        ];
        configPackages = [ wrapperland ];

        wlr.enable = false;
    };

    security = {
        polkit.enable = true;
    };

    programs = {
        dconf.enable = true;
        xwayland.enable = true;
    };

    services.graphical-desktop.enable = true;
}
