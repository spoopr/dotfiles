{
    self,
    ...
}: {
    perSystem = {
        pkgs,
        ...
    }: {
        apps.install-ftz = {
            type = "app";
            program = self.lib.install.mkInstaller
                {
                    inherit pkgs;
                    host = "ftz";
                    disks = [ "portable" ];
                };
        };
    };
}
