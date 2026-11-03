{
    ...
}: {
    dotfiles.core.impermanence.options.paths = [
        "/var/lib/fprint"
    ];

    services.fprintd.enable = true;
}
