{
    ...
}: {
    dotfiles.self.forceEnable = true;

    boot.loader = {
        timeout = 0;

        limine = {
            enable = true;

            maxGenerations = 20;
        };
    };
}
