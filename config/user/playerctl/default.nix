{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        playerctl
    ];
}
