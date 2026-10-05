{
  pkgs,
  ...
}: {
    dotfiles = {
        niri.enable = true;
    };

    environment.systemPackages = with pkgs; [
        tor-browser
    ];
}
