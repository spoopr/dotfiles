{
  pkgs,
  ...
}: let
    placeProfile = pkgs.writeScript "placeMullvadBrowserProfile" ''
        mkdir -p ~/.mullvad/mullvadbrowser/profile
        cp -r ${./profile}/* ~/.mullvad/mullvadbrowser/profile
        chmod +w -R ~/.mullvad/mullvadbrowser/profile
    '';

    wrappervad-browser = (pkgs.symlinkJoin {
        name = "wrappedMullvad-browser";
        paths = [ pkgs.mullvad-browser ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/mullvad-browser \
            --run ${placeProfile} \
            --add-flags "--profile ~/.mullvad/mullvadbrowser/profile"
        '';
    });

in {

    environment.systemPackages = [
        wrappervad-browser
    ];
}
