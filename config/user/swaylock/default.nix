{
  pkgs,
  ...
}: let
    wraplock = pkgs.symlinkJoin {
        name = "wraplock";
        paths = [ pkgs.swaylock ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
            mkdir -p $out/swaylock
            ln -s ${./config} $out/swaylock/config
            wrapProgram $out/bin/swaylock \
                --set "XDG_CONFIG_HOME" "$out"
        '';
    };
in {
    environment.systemPackages = [
        wraplock
    ];

    security.pam.services.swaylock = {};
}
