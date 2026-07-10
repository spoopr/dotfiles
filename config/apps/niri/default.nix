{
  pkgs,
  ...
}: let
    niriWrapped = pkgs.symlinkJoin {
        name = "niriWrapped";
        paths = [ pkgs.niri ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/niri-session \
                --set "NIRI_CONFIG" "${./config.kdl}"
        '';

        passthru = pkgs.niri.passthru;
    };
in {
    environment.systemPackages = [
        niriWrapped
        pkgs.xwayland-satellite
    ] ++ (with pkgs; [
        jq
    ]);

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

    services.displayManager.sessionPackages = [
        niriWrapped
    ];
}
