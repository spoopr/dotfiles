{
  pkgs,
  ...
}: let
    placeProfile = pkgs.writeScript "placeMullvadBrowserProfile" ''
        if [ ! -d ~/.mullvad/mullvadbrowser/profile ]; then
            mkdir -p ~/.mullvad/mullvadbrowser
            tar -xf ${./profile.tar.gz} -C ~/.mullvad/mullvadbrowser/
            chmod +w -R ~/.mullvad/mullvadbrowser/profile
        fi
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
