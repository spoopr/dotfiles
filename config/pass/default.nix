{
  pkgs,
  lib,
  dots,
  ...
}: let
    inherit (dots.inputs) wrappers;
in {
    dotfiles = {
        niri.enable = true;
        firefox.enable = true;

        impermanence.options.paths = [
            {
                directory = "/srv/proton-pass-cli/";
                user = "root";
                group = "proton-pass";
                mode = "660";
            }
        ];
    };

    environment.systemPackages = {
        inherit pkgs;
        package = pkgs.proton-pass-cli;

        env = {
            PROTON_PASS_SESSION_DIR = "/srv/proton-pass-cli/.session";
        };
    }
        |> wrappers.lib.wrapPackage
        |> lib.singleton;

    users.groups."proton-pass".members = [
        "spoopr"
    ];
}
