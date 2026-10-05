{
  ...
}: {
    dotfiles.self.forceEnable = true;

    security = {
        protectKernelImage = true;
        lockKernelModules = true;
        forcePageTableIsolation = true;
    };

    boot = {
        kernelParams = [
            # self explanatory. also works to erase memory on shutdown
            "init_on_free=1"
        ];
    };
}
