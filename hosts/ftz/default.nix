{
    modulesPath,
    lib,
    ...
}: {
    imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ];

    users.users.root.password = lib.mkForce "";


    # normally set by hardware-configuration.nix, but of course there isn't one
    nixpkgs.hostPlatform = "x86_64-linux";
}
