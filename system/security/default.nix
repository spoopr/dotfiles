{
  ...
}: {
    security = {
        protectKernelImage = true;
        lockKernelModules = true;
        forcePageTableIsolation = true;

        auditd.enable = true;
        audit = {
            enable = true;
            rules = [ "-a exit,always -F arch=x86_64 -S execve" ];
        };

        sudo = {
            execWheelOnly = true;
            extraConfig = ''
                Defaults lecture=never

                Defaults timestamp_timeout=0
                Defaults: %wheel rootpw
                %wheel ALL=(ALL) ALL
            '';
        };
    };

    boot = {
        kernelParams = [
            # self explanatory. also works to erase memory on shutdown
            "init_on_free=1"
        ];
    };
}
