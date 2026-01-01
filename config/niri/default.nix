{
  pkgs,
  ...
}: let
    niriWrapped = pkgs.symlinkJoin {
        name = "niriWrapped";
        paths = [ pkgs.niri ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/niri \
                --add-flags "-c ${./config.kdl}"
        '';
    };
in {
    environment.systemPackages = [
        niriWrapped
        pkgs.xwayland-satellite
    ];

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ 
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
        ];
        configPackages = [ niriWrapped ];
    };

    security = {
        polkit.enable = true;
    };

    programs = {
        dconf.enable = true;
    };

    services.graphical-desktop.enable = true;
}
