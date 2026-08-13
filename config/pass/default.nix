{
  pkgs,
  ...
}: {
    dotfiles = {
        niri.enable = true;
    };

    environment.systemPackages = with pkgs; [
        proton-pass
    ];
}
