{
  ...
}: {
    dotfiles.self.forceEnable = true;

    boot = {
        loader = {
            timeout = 0;
        };
    };
}
