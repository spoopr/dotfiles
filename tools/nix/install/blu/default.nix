{
    self,
    ...
}: {
    perSystem = {
        pkgs,
        ...
    }: {
        apps.install-blu = {
            type = "app";
            program = self.lib.install.mkInstaller
                {
                    inherit pkgs;
                    host = "blu";
                    disks = [
                        "system"
                        "aux0"
                        "aux1"
                        "aux2"
                        "aux3"
                    ];
                };
        };
    };
}
