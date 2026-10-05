{
    pkgs,
    ...
}: {
    programs.wireshark = {
        enable = true;
        # nixpkgs config defaults to wireshark-cli
        package = pkgs.wireshark;
    };

    users.users.spoopr.extraGroups = [
        "wireshark"
    ];
}
