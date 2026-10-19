{
    ...
}: {
    dotfiles.self.forceEnable = true;

    programs.gnupg = {
        agent.enable = true;
    };
}
