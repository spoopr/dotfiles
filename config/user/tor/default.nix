{
  pkgs,
  ...
}: {
    dotfiles = {
        user.niri.enable = true;
    };

    environment.systemPackages = with pkgs; [
        tor-browser
    ];
}
